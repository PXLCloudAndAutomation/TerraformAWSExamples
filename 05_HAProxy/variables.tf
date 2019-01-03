variable "region" {
  description = "Region to provision the resources into."
  type = "string"
}

variable "key_pair" {
  description = "Contains the name and the path of the public key."
  type = "map"
}

variable "vpc" {
  type = "map"
}

variable "subnet" {
  type = "map"
}

variable "ami" {
  type = "map"
}

variable "web_server_count" {
}

variable "instance_type" {
  type = "string"
}


