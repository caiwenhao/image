package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"strings"
	"time"
	"path/filepath"
	"github.com/golang/glog"
	"github.com/ceph/go-ceph/cephfs"
	"github.com/kubernetes-incubator/nfs-provisioner/controller"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/pkg/api/v1"
	storage "k8s.io/client-go/pkg/apis/storage/v1beta1"
	"k8s.io/client-go/pkg/types"
	"k8s.io/client-go/pkg/util/uuid"
	"k8s.io/client-go/pkg/util/wait"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

const (
	resyncPeriod              = 15 * time.Second
	provisionerName           = "kubernetes.io/cephfs"
	exponentialBackOffOnError = false
	failedRetryThreshold      = 5
	provisionerIdAnn          = "cephFSProvisionerIdentity"
	cephPathAnn               = "cephPath"
)

type cephFSProvisioner struct {
	// Kubernetes Client. Use to retrieve Ceph admin secret
	client kubernetes.Interface
	// Identity of this cephFSProvisioner, generated. Used to identify "this"
	// provisioner's PVs.
	identity types.UID
}

func NewCephFSProvisioner(client kubernetes.Interface) controller.Provisioner {
	return &cephFSProvisioner{
		client:   client,
		identity: uuid.NewUUID(),
	}
}

var _ controller.Provisioner = &cephFSProvisioner{}

// Provision creates a storage asset and returns a PV object representing it.
func (p *cephFSProvisioner) Provision(options controller.VolumeOptions) (*v1.PersistentVolume, error) {
	if options.PVC.Spec.Selector != nil {
		return nil, fmt.Errorf("claim Selector is not supported")
	}
	_, adminId, adminSecretName, mon, path, err := p.parseParameters(options.Parameters)
	if err != nil {
		return nil, err
	}
	// create random share name
	share := fmt.Sprintf("kubernetes-dynamic-pvc-%s", uuid.NewUUID())
	absPath := filepath.Join(path, "volumes", "kubernetes", share)
	mkErr := os.MkdirAll(absPath, os.ModePerm)
	if mkErr != nil {
		glog.Errorf("failed to provision path %q err: %v", absPath, mkErr)
		return nil, mkErr
	}
	vPath := filepath.Join("/volumes", "kubernetes", share)
	pv := &v1.PersistentVolume{
		ObjectMeta: v1.ObjectMeta{
			Name: options.PVName,
			Annotations: map[string]string{
				provisionerIdAnn: string(p.identity),
				cephPathAnn:      vPath,
			},
		},
		Spec: v1.PersistentVolumeSpec{
			PersistentVolumeReclaimPolicy: options.PersistentVolumeReclaimPolicy,
			AccessModes: []v1.PersistentVolumeAccessMode{
				v1.ReadWriteOnce,
				v1.ReadOnlyMany,
				v1.ReadWriteMany,
			},
			Capacity: v1.ResourceList{ //FIXME: kernel cephfs doesn't enforce quota, capacity is not meaningless here.
				v1.ResourceName(v1.ResourceStorage): options.PVC.Spec.Resources.Requests[v1.ResourceName(v1.ResourceStorage)],
			},
			PersistentVolumeSource: v1.PersistentVolumeSource{
				CephFS: &v1.CephFSVolumeSource{
					Monitors: mon,
					Path:     vPath,
					SecretRef: &v1.LocalObjectReference{
						Name: adminSecretName,
					},
					ReadOnly: false,
					User:     adminId,
				},
			},
		},
	}

	glog.Infof("successfully created CephFS share %+v", pv.Spec.PersistentVolumeSource.CephFS)

	return pv, nil
}

// Delete removes the storage asset that was created by Provision represented
// by the given PV.
func (p *cephFSProvisioner) Delete(volume *v1.PersistentVolume) error {
	ann, ok := volume.Annotations[provisionerIdAnn]
	if !ok {
		return errors.New("identity annotation not found on PV")
	}
	if ann != string(p.identity) {
		return &controller.IgnoredError{"identity annotation on PV does not match ours"}
	}
	share, ok := volume.Annotations[cephPathAnn]
	if !ok {
		return errors.New("ceph share annotation not found on PV")
	}
	rmErr := os.RemoveAll(share)
	if rmErr != nil {
		glog.Errorf("failed to delete share %q err: %v", share, rmErr)
		return rmErr
	}

	return nil
}

func (p *cephFSProvisioner) parseParameters(parameters map[string]string) (string, string, string, []string, string, error) {
	var (
		mon                                                                        []string
		cluster, adminId, adminSecretName, path string
	)

	adminId = "admin"
	path = "/mnt"
	cluster = "ceph"

	for k, v := range parameters {
		switch strings.ToLower(k) {
		case "cluster":
			cluster = v
		case "monitors":
			arr := strings.Split(v, ",")
			for _, m := range arr {
				mon = append(mon, m)
			}
		case "path":
			path = v
		case "adminid":
			adminId = v
		case "adminsecretname":
			adminSecretName = v
		default:
			return "", "", "", nil, "", fmt.Errorf("invalid option %q", k)
		}
	}
	// sanity check
	if adminSecretName == "" {
		return "", "", "", nil, "", fmt.Errorf("missing Ceph admin secret name")
	}
	if len(mon) < 1 {
		return "", "", "", nil, "", fmt.Errorf("missing Ceph monitors")
	}
	return cluster, adminId, adminSecretName, mon, path, nil
}

func (p *cephFSProvisioner) parsePVSecret(namespace, secretName string) (string, error) {
	if p.client == nil {
		return "", fmt.Errorf("Cannot get kube client")
	}
	secrets, err := p.client.Core().Secrets(namespace).Get(secretName)
	if err != nil {
		return "", err
	}
	for _, data := range secrets.Data {
		return string(data), nil
	}

	// If not found, the last secret in the map wins as done before
	return "", fmt.Errorf("no secret found")
}

func (p *cephFSProvisioner) getClassForVolume(pv *v1.PersistentVolume) (*storage.StorageClass, error) {
	className, found := pv.Annotations["volume.beta.kubernetes.io/storage-class"]
	if !found {
		return nil, fmt.Errorf("Volume has no class annotation")
	}

	class, err := p.client.Storage().StorageClasses().Get(className)
	if err != nil {
		return nil, err
	}
	return class, nil
}

var (
	master     = flag.String("master", "", "Master URL")
	kubeconfig = flag.String("kubeconfig", "", "Absolute path to the kubeconfig")
)

func main() {
	flag.Parse()
	flag.Set("logtostderr", "true")

	var config *rest.Config
	var err error
	if *master != "" || *kubeconfig != "" {
		config, err = clientcmd.BuildConfigFromFlags(*master, *kubeconfig)
	} else {
		config, err = rest.InClusterConfig()
	}

	if err != nil {
		glog.Fatalf("Failed to create config: %v", err)
	}
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		glog.Fatalf("Failed to create client: %v", err)
	}

	// The controller needs to know what the server version is because out-of-tree
	// provisioners aren't officially supported until 1.5
	serverVersion, err := clientset.Discovery().ServerVersion()
	if err != nil {
		glog.Fatalf("Error getting server version: %v", err)
	}

	// Create the provisioner: it implements the Provisioner interface expected by
	// the controller
	cephFSProvisioner := NewCephFSProvisioner(clientset)

	// Start the provision controller which will dynamically provision cephFS
	// PVs
	pc := controller.NewProvisionController(clientset, resyncPeriod, provisionerName, cephFSProvisioner, serverVersion.GitVersion, exponentialBackOffOnError, failedRetryThreshold)
	pc.Run(wait.NeverStop)
}