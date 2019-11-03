provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "main" {
  key_name   = "${var.key_pair["name"]}"
  public_key = "${file(var.key_pair["public_path"])}"
}

locals {
  az-subnet-id-mapping = "${zipmap(aws_subnet.main.*.tags.Name, aws_subnet.main.*.id)}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc["cidr_block"]}"

  tags = {
    Name = "${var.vpc["name"]}"
  }
}

# Internet gateway to give the public IPs in the  VPC internet access.
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "Main gateway"
  }
}

# A catch all unkown traffic route for the gateway.
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_subnet" "main" {
  count = "${length(var.subnets)}"

  cidr_block              = "${lookup(var.subnets[count.index], "cidr")}"
  vpc_id                  = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${lookup(var.subnets[count.index], "az")}"

  tags = {
    Name = "${lookup(var.subnets[count.index], "name")}"
  }
}

resource "aws_security_group" "allow-ssh-and-egress" {
  name = "main"

  description = "Allows SSH traffic into instances as well as all eggress."
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh-all"
  }
}

resource "aws_instance" "server_one" {
  instance_type = "${var.server_one["instance_type"]}"
  ami           = "${var.ami["id"]}"
  key_name      = "${aws_key_pair.main.id}"
  subnet_id     = "${local.az-subnet-id-mapping["subnet1"]}"
  private_ip    = "${var.server_one["private_ip"]}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh-and-egress.id}",
  ]

  tags = {
    Name = "${var.server_one["name"]}"
  }
}

resource "aws_instance" "server_two" {
  instance_type = "${var.server_two["instance_type"]}"
  ami           = "${var.ami["id"]}"
  key_name      = "${aws_key_pair.main.id}"
  subnet_id     = "${local.az-subnet-id-mapping["subnet2"]}"
  private_ip    = "${var.server_two["private_ip"]}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh-and-egress.id}",
  ]

  tags = {
    Name = "${var.server_two["name"]}"
  }
}

output "server_one_ssh_command" {
  value = "ssh -i ${var.key_pair["private_path"]} ${var.ami["user"]}@${aws_instance.server_one.public_ip}"
}

output "server_two_ssh_command" {
  value = "ssh -i ${var.key_pair["private_path"]} ${var.ami["user"]}@${aws_instance.server_two.public_ip}"
}
