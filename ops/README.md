# Republic

Create a Docker Swarm cluster on DigitalOcean using Ansible. The cluster is backed by Consul and the connections are managed by HAProxy.

## How it Works

The `swarm` consists of two types of machines. Platform machines and Workers. You should have 3 or 5 Platform instances. You can have any number of Workers.

Worker instances run `docker`, `swarm` and `consul` in client mode. The also run `consul-template` and `registrator`.

Platform instances run everything Worker instances run, but they also run `haproxy` and `consul` in server mode. The script updates the DNS record so that the main A record contains the IP addresses of all the platform instances giving DNS level redundancy. 

When a `docker` container is pushed to the `swarm`, it is pushed to one of the platform instances which then runs it on one of the instances (worker or platform). When the container is run, it alerts the `registrator` container, which in turn registers the container with `consul`. `consul-template` is watching all changes to `consul` and updates the `haproxy` config on all the platform instances so requests to any of the platform instances will route to the correct container.

## Setup

### Required Variables

 * REDIS_URL
 * DIGITALOCEAN_KEY_ID
 * DIGITALOCEAN_TOKEN
 * AWS_ACCESS_KEY_ID
 * AWS_SECRET_ACCESS_KEY
 * AWS_HOSTED_ZONE_ID

## Usage

To get started, add 3 platform workers:


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

`./bin/ops platform` yields:

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
