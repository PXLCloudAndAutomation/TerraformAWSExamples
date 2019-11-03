resource "aws_vpc" "main" {
  cidr_block = "${var.cidr}"

  tags = {
    Name = "${var.name}"
  }
}

# Internet gateway to give the public IPs in the  VPC internet access.
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

# A catch all unkown traffic route for the gateway.
resource "aws_subnet" "main" {
  count = "${length(var.az-subnet-mapping)}"

  cidr_block              = "${lookup(var.az-subnet-mapping[count.index], "cidr")}"
  vpc_id                  = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${lookup(var.az-subnet-mapping[count.index], "az")}"

  tags = {
    Name = "${lookup(var.az-subnet-mapping[count.index], "name")}"
  }
}
