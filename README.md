SHARED
======

Shared Infrastructure



NOTES
=====


consul members
consul join <ip>

curl http://localhost:8500/v1/catalog/service/swarm

curl http://localhost:8500/agent/services

dig @127.0.0.1 -p 8600 swarm.service.consul SRV



swarm manage --discovery consul://localhost:8500/v1/catalog/service/swarm -H=107.170.121.184:2375

swarm list --discovery consul://localhost:8500/v1/catalog/service/swarm

docker -H 104.131.230.67:4243 run -d -e "DOCKER_HOST=104.131.230.67:4243" -h $HOSTNAME progrium/registrator consul:
docker -H 104.131.230.67:4243 run -d -e "DOCKER_HOST=104.131.230.67:4243" -h $HOSTNAME progrium/registrator consul://104.131.230.67:8500


MODULES
=======

Hosting: DigitalOcean
Provisioning: Ansible
Service Discovery: Consul
Containers: Docker
Load Balancing HAProxy
DNS: Route53


DOCKER REGISTRY
===============

docker run -d \
        --name=registry
        -e SETTINGS_FLAVOR=s3 \
        -e AWS_BUCKET=nestedset-docker-registry \
        -e STORAGE_PATH=/registry \
        -e AWS_KEY=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET=$AWS_SECRET_ACCESS_KEY \
        -e SEARCH_BACKEND=sqlalchemy \
        -e "SERVICE_NAME=registry" 
        -e "SERVICE_TAGS=http" 
        --name=registry.0
        -p 5000:5000 \
        registry


docker push 104.131.230.67:5000/hubothosting


OPS TODO
========
Add consul-template and HAProxy template
Add tls for swarm/consul
Add volumes and volume backups... somehow.
Add docker container for docker registry
Add docker container for consul-ui
Add docker container for postgres


ops platform add 3
ops worker add 2
ops status
--- wait ---
ops provision
ops join




BIGGER PICTURE TODO
===================

Finish platform
  logging
  db
  db backups
Move cilantro attachments to s3
Move cilantro to platform
hubothosting on platform
Thank you card app - lob.com
dropsearch (personal search engine, rebuild greplin)
Markdownplus (julia microservice?)





TLS
===

mkdir ~/.tls
pushd ~/.tls

# SERIAL FILE
echo 01 > ca.srl
# GENERATE CA KEY
openssl genrsa -des3 -out ca-key.pem 2048
# GENERATE CA CERT
openssl req -new -x509 -days 365 -key ca-key.pem -out ca.pem

# CREATE SERVER KEY AND CSR
openssl genrsa -des3 -out server-key.pem 2048
openssl req -subj '/CN=nestedset.com' -new -key server-key.pem -out server.csr
# SIGN THE KEY WITH OUR CA
openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem -out server-cert.pem

# CREATE CLIENT KEY AND CSR
openssl genrsa -des3 -out key.pem 2048
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
# MAKE SUITABLE FOR CLIENT (AND SERVER) AUTH
echo extendedKeyUsage = clientAuth,serverAuth > extfile.cnf
# SIGN THE KEY WITH OUR CA
openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf

# REMOVE THE PASSPHRASE FROM BOTH KEYS
openssl rsa -in server-key.pem -out server-key.pem
openssl rsa -in key.pem -out key.pem

popd ~/.tls


RUN SOME CONTAINERS
===================

export DOCKER_HOST=tcp://162.243.105.198:2375
docker run -d -e "SERVICE_NAME=db1" -e "SERVICE_TAGS=redis" --name=redis.0 -p 10000:6379 dockerfile/redis
docker run -d -e "SERVICE_NAME=db2" -e "SERVICE_TAGS=redis" --name=redis.1 -p 10001:6379 dockerfile/redis
docker run -d -e "SERVICE_NAME=db3" -e "SERVICE_TAGS=redis" --name=redis.2 -p 10002:6379 dockerfile/redis
docker run -d -e "SERVICE_NAME=db4" -e "SERVICE_TAGS=redis" --name=redis.3 -p 10003:6379 dockerfile/redis
docker run -d -e "SERVICE_NAME=db5" -e "SERVICE_TAGS=redis" --name=redis.4 -p 10004:6379 dockerfile/redis
docker run -d -e "SERVICE_NAME=db6" -e "SERVICE_TAGS=redis" --name=redis.5 -p 10005:6379 dockerfile/redis
docker run -d -e "SERVICE_NAME=db7" -e "SERVICE_TAGS=redis" --name=redis.6 -p 10006:6379 dockerfile/redis
docker run -d -e "SERVICE_NAME=db8" -e "SERVICE_TAGS=redis" --name=redis.7 -p 10007:6379 dockerfile/redis
docker run -d -e "SERVICE_NAME=db9" -e "SERVICE_TAGS=redis" --name=redis.8 -p 10008:6379 dockerfile/redis


machine create --driver digitalocean --digitalocean-access-token=$MACHINE_DIGITALOCEAN_TOKEN republic-machine-1

#server
docker --tlsverify --tlscacert=/etc/tls/ca.cert.pem --tlscert=/etc/tls/docker.cert.pem --tlskey=/etc/tls/docker.private_key.pem ps

#client
docker --verbose --tlsverify --tlscacert=.tls/ca.cert.pem --tlscert=./$HOST.cert.pem --tlskey=.tls/$HOST.private_key.pem -H 104.131.230.67:4243 ps


openssl verify -verbose -CAfile .tls/ca.cert.pem .tls/republic-leader-1.cert.pem

# CA
openssl genrsa -out CAkey.pem 2048
openssl req -config openssl.cnf -new -key cakey.pem -x509 -days 3650 -out ca.pem

# SWARM
openssl genrsa -out swarmkey.pem 2048
openssl req -subj "/CN=nestedset.com" -new -key swarmkey.pem -out swarm.csr

openssl x509 -req -days 3650 -in swarm.csr -CA ca.pem -CAkey CAkey.pem -CAcreateserial -out swarmCRT.pem -extensions v3_req -extfile openssl.cnf
openssl rsa -in swarmkey.pem -out swarmkey.pem

# NODES
openssl genrsa -out node01KEY.pem 2048
openssl req -subj "/CN=node1" -new -key node01KEY.pem -out node01.csr

Sign your certificate
openssl x509 -req -days 3650 -in node01.csr -CA ca.pem -CAkey CAkey.pem -CAcreateserial -out node01CRT.pem -extensions v3_req -extfile openssl.cnf
openssl rsa -in node01KEY.pem -out node01KEY.pem