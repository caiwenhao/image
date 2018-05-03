## jekins 构建
```
cd Web
sed -i 's/$(pwd)/\/tmp/g' build_c.sh
docker run -i --rm=true -v ${WORKSPACE}/${project}:/tmp/ reg.lifesense.com/lifesense/gcc:4.8 /bin/bash /tmp/Web/build_c.sh linux
```