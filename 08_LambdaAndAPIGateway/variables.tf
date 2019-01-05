variable "region" {
  description = "The AWS region to create things in."
  type = "string"
}

variable "code_archive" {
  type = "map"
}

variable "lambda_function_name" {
  type = "string"
}
