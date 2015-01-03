# Ops

My personal PaaS

## Leaders (Recommended 3 or 5)

These are the cluster leaders. 

Leaders do the following:

 * Run consul in server mode
 * _Run HAProxy with consul_template to dynamically configure services_
 * Are included in the main A record
 * Run docker (including registrator container)
 * Run swarm
 * _Run syslog_

## Manager (0 or 1)

Acts as the DOCKER_HOST for deploying containers.

The manager does the following:

 * Usually one of the leader nodes, but not required. (Could even run on your laptop)
 * Runs swarm manager

## Workers (Any number)

Workers provide docker resources to swarm.

Workers do the following:

 * Run consul in agent mode
 * Run docker (including registrator container)
 * Run swarm
 * _Run syslog_


## Database (currently 1)

Runs postgres.

Database servers do the following:

 * Run consul in agent mode
 * Run postgres
 * Manage database backups

 