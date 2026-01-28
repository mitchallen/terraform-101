
# terraform-101

See article:

* [Getting Started with Terraform (Docker, Mac, IaC)](./docs/getting-started-with-terraform-docker-mac.md)

## Usage

### Install Terraform (Mac)

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

terraform version
```

## Make sure Docker is running

### See if the docker daemon is running

```sh
docker ps
```

### Install Docker Desktop

If you need to install docker:

* https://docs.docker.com/desktop/install/mac-install/

### Open Docker Desktop

This will start the docker daemon if it isn't running:

```sh
open -a Docker
```

Check it again:

```sh
docker ps
```

## Terraform

### Init the plan

```sh
terraform init
``` 

### Run the plan

If using Docker for Mac, run this first:

```sh
export TF_VAR_docker_endpoint=unix://$HOME/.docker/run/docker.sock
```

```sh
terraform plan
```

If you run into issues with Docker, check the current context:

```sh
docker context ls
```

### Apply the plan

If using Docker for Mac, run this first:

```sh
export TF_VAR_docker_endpoint=unix://$HOME/.docker/run/docker.sock
```

```sh
terraform apply
```

### Verify the server is up

```sh
docker ps
```

If you have a lot of containers running already, you can filter with:

```sh
docker ps | grep random
```

### Test the server

```sh
curl http://localhost:1220/v1/people/1

curl http://localhost:1220/v1/words/1

curl http://localhost:1220/v1/values/1

curl http://localhost:1220/v1/coords/1
```

For more commands see:

* https://github.com/mitchallen/random-server

### Destroy the plan

```sh
terraform destroy
```

### Verify the container is gone

```sh
docker ps
```

## References

* https://developer.hashicorp.com/terraform/cli/commands/plan
* https://spacelift.io/blog/terraform-plan
* https://developer.hashicorp.com/terraform/downloads
* https://dev.to/pavanbelagatti/using-terraform-to-manage-infrastructure-resources-32da
* https://dockerlabs.collabnix.com/advanced/automation/terraform/terraform-mac-nginx.html
* https://developer.hashicorp.com/terraform/tutorials/docker-get-started/docker-build
* https://stackoverflow.com/questions/73451024/where-to-find-information-about-the-following-terraform-provider-attribute-depre
* https://raw.githubusercontent.com/github/gitignore/main/Terraform.gitignore
