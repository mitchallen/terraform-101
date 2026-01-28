// Author: Mitch Allen
// File: main.tf

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
}

// export TF_VAR_docker_endpoint=unix://$HOME/.docker/run/docker.sock
provider "docker" {
  // docker context ls 
  host = var.docker_endpoint
}

# Create a docker image resource
# -> docker pull mitchallen/random-server:latest
resource "docker_image" "random" {
  name         = "ghcr.io/mitchallen/random-server:latest"
  keep_locally = false
}

# Create a docker container resource
# -> same as 'docker run --name random -p1220:3100 mitchallen/random-server:latest'
resource "docker_container" "random" {
  image = docker_image.random.image_id
  name  = "random"
  ports {
    internal = 3100
    external = 1220
  }
}