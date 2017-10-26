FROM centos:7
ADD cephfs-provisioner /usr/local/bin/cephfs-provisioner
CMD chmod x+o /usr/local/bin/cephfs_provisioner
ENV LANG en_US.UTF-8
ENV RES_OPTIONS "timeout:1 attempts:1 ndots:2"
CMD ["/usr/local/bin/cephfs-provisioner"]