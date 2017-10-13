# disconf编译说明

1.编译环境

```shell
mkdir -p /data/tmp & cd /data/tmp/
yum install git java maven
```

2.编译disocnf

```shell
git clone  https://github.com/caiwenhao/disconf.git
cp disconf-web/profile/rd/application-demo.properties disconf-web/profile/rd/application.properties
ONLINE_CONFIG_PATH=/data/tmp/disconf/disconf-web/profile/rd
WAR_ROOT_PATH=/data/tmp/war
export ONLINE_CONFIG_PATH
export WAR_ROOT_PATH
cd disconf-web
sh deploy/deploy.sh
```

3.编译 dockerfile

```shell
cp /data/tmp/war/disconf-web.war .
cp -a /data/tmp/war/html .
docker build . -t reg.lifesense.com/lifesense/disconf:v0.0.0
```