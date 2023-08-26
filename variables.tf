// Author: Mitch Allen
// File: variables.tf

variable "docker_endpoint" {
  default = "unix:///var/run/docker.sock"
}