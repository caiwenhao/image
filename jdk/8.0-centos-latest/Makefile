NAME=tomcat
VERSION=8.0-centos-latest
PROJECT_ID=lifesense
PROJECT=reg.lifesense.com/${PROJECT_ID}



all: build

build:
	docker build --pull -t ${PROJECT}/${NAME}:${VERSION} .

push: build
	docker push ${PROJECT}/${NAME}:${VERSION}

.PHONY: all build push
