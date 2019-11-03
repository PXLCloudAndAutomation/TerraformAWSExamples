provider "aws" {
  region = "us-east-1"
}

# Do not forget to run ./create_ssh_keys_local.sh before using terraform plan/apply.
resource "aws_key_pair" "server_key" {
  key_name   = "server_key"
  public_key = "${file("./key/id_rsa.pub")}"
}

# Terraform doesn't want to work with a data block for the default VPC. :-/
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC" 
  }
}

resource "aws_security_group" "allow-ssh-ping-and-egress" {
  name = "allow-ssh-ping-and-egress"

  description = "Allows SSH and Ping traffic into instances as well as all eggress."
  vpc_id      = "${aws_default_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-ping-and-egress" 
  }
}

resource "aws_instance" "server" {
  # ami = "ami-0ac019f4fcb7cb7e6" # Ubuntu 18.04, login: ubuntu
  ami = "ami-011b3ccf1bd6db744" # RHEL, login: ec2-user 
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.server_key.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh-ping-and-egress.id}",
  ]
  
  tags = {
    Name = "ServerFromTerraform" 
  }
}

output "server_ip" {
  value = "${aws_instance.server.public_ip}"
}
