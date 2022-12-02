
# terraform-101

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

This will start docker daemon if it isn't running:

```sh
open -a Docker
```

Check it again:

```sh
docker ps
```

## Init the plan

```sh
terraform init
``` 

### Run the plan

```sh
terraform plan
```

### Apply the plan

```sh
terraform apply
```

### Verify the server is up

```sh
docker ps
```

If you have a lot of container running already, you can filter with:

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

* https://hub.docker.com/r/mitchallen/random-server

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
* https://hub.docker.com/r/mitchallen/random-server
* https://dev.to/pavanbelagatti/using-terraform-to-manage-infrastructure-resources-32da
* https://dockerlabs.collabnix.com/advanced/automation/terraform/terraform-mac-nginx.html
* https://developer.hashicorp.com/terraform/tutorials/docker-get-started/docker-build
* https://stackoverflow.com/questions/73451024/where-to-find-information-about-the-following-terraform-provider-attribute-depre
* https://raw.githubusercontent.com/github/gitignore/main/Terraform.gitignore
