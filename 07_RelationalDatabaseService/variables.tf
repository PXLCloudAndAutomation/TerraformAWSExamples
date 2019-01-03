variable "region" {
  description = "Region to provision the resources into."
  type = "string"
}

variable "vpc" {
  type = "map"
}

variable subnet_1 {
  type = "map"
}

variable subnet_2 {
  type = "map"
}

variable "security_group" {
  type = "map"
}

variable "identifier" {
  description = "Identifier for your AWS RDS"
  type = "string"
}

variable "storage" {
  description = "Storage size in GB"
  type = "string"
}

variable "engine" {
  description = "Engine type, example values mysql, postgres"
  type = "string"
}

variable "engine_version" {
  description = "Engine version"
  type = "map"
}

variable "instance_class" {
  type = "string"
}

variable "db_name" {
  type = "string"
}

variable "username" {
  type = "string"
}

variable "password" {
  type = "string"
}
