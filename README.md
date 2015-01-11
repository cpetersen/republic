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

OPS TODO
========
Bring back ssh check ("active" vs "waiting for ssh")
  Make swarm manage work (can't reach swarm workers)
  Add HAProxy
Add consul-template and HAProxy template
Add tls for swarm
Add tls for consul
ops X destroy should take node name parameters
ops destroy_all should become destroy and should take node name parameters as well as --all flag
create ops platform elect-leader
move ops join to ops platform join
ops join should take node name parameters
can all leaders run manager? Make part of join (and remove manage and select_manager steps)?
Get rid of db, simplify ops script
Add volumes and volume backups... somehow.

ops platform add 3
ops status
--- wait ---
ops provision
ops join
ops platform select_manager NAME
ops platform manage

# ops platform elect-leader # Doesn' exist yet
# ops platform join # should move under platform




BIGGER PICTURE TODO
===================

Finish platform
  logging
  db
  db backups
Move cilantro attachments to s3
Move cilantro to platform
hubothosting on platform
fastforward on platform
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

docker -H 107.170.121.184:2375 run -d --name redis.0 -p 10000:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.1 -p 10001:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.2 -p 10002:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.3 -p 10003:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.4 -p 10004:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.5 -p 10005:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.6 -p 10006:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.7 -p 10007:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.8 -p 10008:6379 dockerfile/redis
docker -H 107.170.121.184:2375 run -d --name redis.9 -p 10009:6379 dockerfile/redis

