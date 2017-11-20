NAME=jdk
VERSION=1.8.0-centos7
PROJECT_ID=lifesense
PROJECT=reg.lifesense.com/${PROJECT_ID}



all: build

build:
	docker build --pull -t ${PROJECT}/${NAME}:${VERSION} .

push: build
	docker push ${PROJECT}/${NAME}:${VERSION}

.PHONY: all build push
