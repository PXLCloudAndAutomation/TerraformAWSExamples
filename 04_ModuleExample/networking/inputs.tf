variable "cidr" {
  description = "CIDR block to assign to the VPC"
  type        = "string"
}

variable "name" {
  type = "string"
}

variable "az-subnet-mapping" {
  type        = "list"
  description = "Lists the subnets to be created in their respective AZ."
}
