NAME=cephfs-provisioner
VERSION=v0.0.1
PROJECT_ID=lifesense
PROJECT=reg.lifesense.com/${PROJECT_ID}

all: build

build:
    go build cephfs-provisioner.go
	docker build --pull -t ${PROJECT}/${NAME}:${VERSION} .


push: build
	docker push ${PROJECT}/${NAME}:${VERSION}

.PHONY: all build push
