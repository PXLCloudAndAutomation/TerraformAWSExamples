resource "aws_vpc" "main" {
  cidr_block = "${var.vpc["cidr_block"]}"

  enable_dns_hostnames = true

  tags {
    Name = "${var.vpc["name"]}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_1["cidr"]}"
  availability_zone = "${var.subnet_1["az"]}"

  tags {
    Name = "${var.subnet_1["name"]}"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_2["cidr"]}"
  availability_zone = "${var.subnet_2["az"]}"

  tags {
    Name = "${var.subnet_2["name"]}"
  }
}

