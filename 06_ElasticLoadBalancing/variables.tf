variable "region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
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


