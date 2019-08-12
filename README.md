# Self-hosted Registry and Repository

Ansible scripts to deploy and configure a self-hosted git source code server and Docker registry as Docker containers.

## Prerequisites

### Ansible

[Ansible](https://www.ansible.com/) is required to be installed on the host that scripts are being run from.
### Docker

[Docker](https://www.docker.com) is required to be installed on the target host.

### Environment Settings

In order to make the deployment of the services portable between host environments host specific variables have been paramterised. The default variables are defined within the file [`vars/base.yml`](vars/base.yml), see the following section for details of the variables. Each of these variables can be overrided if necessary. The preferred method of overriding the variables is to create a new file within the directoy [`vars/env`](vars/env) and create a new file containing only the variables which are required to be changed. The file created needs to be referenced within the playbook file [`self-hosted-registry-repository.yml`](self-hosted-registry-repository.yml) under the code block `###### START: MANAGE HOST ENVIRONMENT FILES HERE ######`.

### Role Variables

#### `host_name`

- Name of host machine
- Default value: "{{ ansible_hostname }}"

#### `host_ip`

- IP address of host machine
- Default value: "{{ ansible_default_ipv4.address }}"

#### `host_store`

- Location on local file system where files are written to
- Default value: "{{ ansible_user_dir }}/.local-registry-repository"


user_name: "{{ ansible_user_id }}"
user_fullname: "{{ ansible_user_gecos }}"
user_home: "{{ ansible_user_dir }}"

services_recreate: yes
services_restart_policy: "always"
services_restart_restarts: 10

internal_repository_host: "repository.service.consul"
internal_repository_ports_http: "10800"
internal_repository_ports_https: 
internal_repository_service: gogs
internal_registry_host: master_node
internal_registry_service: registry

external_repository_host:
external_repository_name: 
external_repository_project:
external_repository_ports_http:
external_repository_ports_https:
external_registry_host: 
external_registry_ports_http: 
external_registry_ports_pull:
external_registry_ports_push:
external_registry_project:
external_registry_authorise: no

env:
  PATH: "{{ ansible_env.PATH }}:{{ ansible_env.HOME }}/.local/bin"

dns_primary: "8.8.8.8"
dns_secondary: "8.8.4.4"

domain:

proxy: 
no_proxy_list: 


### Service Variables

Variable associated with each service are located within the the `vars` directory for each role.

#### Service Versions

In order to change the version of a service modify the value for the `tag` key.

#### Service Images Source

The location from which a service is pulled can changed by modifying the value for the `src` key.

### Artifacft Versions

The aritficats, source-code projects and docker images, that will be populated into the repository and registry respectively are defined within the file [`vars/artifacts.yml`](vars/artifacts.yml).

## What is installed

![self-hosted-registry-repository-deployment](docs/self-hosted-registry-repository.png)

### DevOps

[Gitlab](https://about.gitlab.com/) to provide support the software development process from project planning and source code management to CI/CD, monitoring, and security. Gitlab is made accessible via port 10080 for insecure and 10443 for secure. [Gitlab-runner](https://docs.gitlab.com/runner/) is also installed as Docker container to support CI. See instructions at https://docs.gitlab.com/runner/register/index.html#docker.

### Docker Registry

The [Docker Registry](https://docs.docker.com/registry/) provided by Docker is installed and made accessible via ports 7000 for insecure and 7001 for secure. In addition, the [Docker Registy UI](https://hub.docker.com/r/joxit/docker-registry-ui/) is provided to use a web-based UI for the registry. The Docker Registy UI is available via port 8000. Self-signed certificates for the registry are created and copied into the certificate path for Docker.

## Installation

The Ansible scripts are configured to be run on the the host machine that the services are to be installed on. Modify the file [`hosts.yml`](./hosts.yml) if it is required to install the services on a different host.

Install using

```bash
./run_playbook.sh
```

## Populating the registry and repository

The scripts [`populate-registry.sh`](./populate-registry.sh) and [`populate-repository.sh`](./populate-repository.sh) are provided to use populate the registry and repository, respectively. The images and projects which will be copied into the registry and repository, respectively, are defined within the file [`vars/artifacts.yml`](vars/artifacts.yml).
