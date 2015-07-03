# Republic

Create a Docker Swarm cluster on DigitalOcean using Ansible. The cluster is backed by Consul and the connections are managed by HAProxy.

## How it Works

The `swarm` consists of two types of machines. Platform machines and Workers. You should have 3 or 5 Platform instances. You can have any number of Workers.

Worker instances run `docker`, `swarm` and `consul` in client mode. The also run `consul-template` and `registrator`.

Platform instances run everything Worker instances run, but they also run `haproxy` and `consul` in server mode. The script updates the DNS record so that the main A record contains the IP addresses of all the platform instances giving DNS level redundancy. 

When a `docker` container is pushed to the `swarm`, it is pushed to one of the platform instances which then runs it on one of the instances (worker or platform). When the container is run, it alerts the `registrator` container, which in turn registers the container with `consul`. `consul-template` is watching all changes to `consul` and updates the `haproxy` config on all the platform instances so requests to any of the platform instances will route to the correct container.

## Setup

### Required Shell Variables

 * REDIS_URL - for storing shared state. This allows you to manage the same cluster from any computer that can access this instance of redis.
 * DIGITALOCEAN_TOKEN - for creating and destroying droplets
 * DIGITALOCEAN_KEY_ID - the ssh key you want to use
 * AWS_ACCESS_KEY_ID - AWS credentials, republic uses Route53 for DNS
 * AWS_SECRET_ACCESS_KEY
 * AWS_HOSTED_ZONE_ID - the zone to point at this cluster

## Usage

## Quick Start

To get started, add 3 platform workers and handful of workers (You can add workers at anytime using the same series of commands):

```shell
./bin/republic leader add 3
./bin/republic worker add 5
```

Now wait for the instances to start. You can check on their progress with:

```shell
./bin/republic status
```

Finally, provision the machines and join the cluster.

```shell
./bin/republic provision
./bin/republic join
```

## CLI Help

`./bin/ops` yields:

```
  republic backup               # Backup redis connection
  republic config               # Setup client configuration for the leader
  republic destroy NAME         # Destroy specific machines of any type in the cluster
  republic help [COMMAND]       # Describe available commands or one specific command
  republic inventory            # Generate ansible inventory file in the current directory
  republic join                 # Join the cluster
  republic leader [SUBCOMMAND]  # Manage the leader machines
  republic provision            # Provision the machines in the cluster
  republic status               # Get status of all machine groups
  republic tls [SUBCOMMAND]     # Manage tls
  republic worker [SUBCOMMAND]  # Manage the worker machines
```

`./bin/ops leader` yields:

```
  republic leader add N           # Add machines to the cluster
  republic leader destroy         # Destroy the machines in the cluster
  republic leader dns             # Update the dns records
  republic leader help [COMMAND]  # Describe subcommands or one specific subcommand
  republic leader status          # Check the status of machines in the cluster
```

`./bin/ops worker` yields:

```
  republic worker add N           # Add machines to the cluster
  republic worker destroy         # Destroy the machines in the cluster
  republic worker help [COMMAND]  # Describe subcommands or one specific subcommand
  republic worker status          # Check the status of machines in the cluster
```

`./bin/ops tls` yields:

```
  republic tls help [COMMAND]  # Describe subcommands or one specific subcommand
  republic tls init            # Init the tls keys
  republic tls node NODE       # Create the certs for a specific node
```
