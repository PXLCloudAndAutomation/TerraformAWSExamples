provider "aws" {
  version = "~> 1.54"
  region = "${var.region}"
}

module "networking" {
  source = "./networking"
  cidr   = "${var.vpc["cidr_block"]}"
  name   = "${var.vpc["name"]}"

  "az-subnet-mapping" = "${var.subnets}"
}


resource "aws_instance" "server_one" {
  instance_type = "${var.instance_type}"
  ami           = "${var.ami["id"]}"
  key_name      = "${aws_key_pair.main.id}"
  subnet_id     = "${module.networking.az-subnet-id-mapping["subnet1"]}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh-and-egress.id}",
  ]
}

resource "aws_instance" "server_two" {
  instance_type = "${var.instance_type}"
  ami           = "${var.ami["id"]}"
  key_name      = "${aws_key_pair.main.id}"
  subnet_id     = "${module.networking.az-subnet-id-mapping["subnet2"]}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh-and-egress.id}",
  ]
}

output "server_one_ssh_command" {
  value = "ssh -i ${var.key_pair["private_path"]} ${var.ami["user"]}@${aws_instance.server_one.public_ip}"
}

output "server_two_ssh_command" {
  value = "ssh -i ${var.key_pair["private_path"]} ${var.ami["user"]}@${aws_instance.server_two.public_ip}"
}
