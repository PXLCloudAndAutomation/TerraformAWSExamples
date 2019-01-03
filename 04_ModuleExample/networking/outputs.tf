# Creates a mapping between subnet name and generated subnet ID.
#
# Given an `aws_subnet` resource created with `count`, we can access
# properties from the list of resources created as a list by using
# the wildcard syntax:
# 
#     <resource>.*.<property>
#
# By making use of `zipmap` we can take two lists and create a map
# that uses the values from the first list as keys and the values
# from the seconds list as values.
#
# Example output:
#
#     az-subnet-id-mapping = {
#       subnet1 = subnet-3b92c15c
#       subnet2 = subnet-a90023f1
#     }
#
output "az-subnet-id-mapping" {
  value = "${zipmap(aws_subnet.main.*.tags.Name, aws_subnet.main.*.id)}"
}

output "vpc-id" {
  description = "ID of the generated vpc"
  value       = "${aws_vpc.main.id}"
}
