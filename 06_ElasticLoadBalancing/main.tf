provider "aws" {
  version = "~> 1.54"
  region = "${var.region}"
}

resource "aws_key_pair" "main" {
  key_name   = "${var.key_pair["name"]}"
  public_key = "${file(var.key_pair["public_path"])}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc["cidr_block"]}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.vpc["name"]}"
  }
}

resource "aws_subnet" "web" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.subnet["cidr"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.subnet["az"]}"

  tags {
    Name = "${var.subnet["name"]}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Main gateway"
  }
}

resource "aws_route_table" "catch_all" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "Catch All Route table"
  }
}

resource "aws_route_table_association" "web_subnet_catch_all" {
  subnet_id      = "${aws_subnet.web.id}"
  route_table_id = "${aws_route_table.catch_all.id}"
}

resource "aws_security_group" "ssh_http_and_all_egress" {
  name        = "SSH-HTPP-and-all-egress-group"
  description = "Used in the example"
  vpc_id      = "${aws_vpc.main.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our elb security group to access
# the ELB over HTTP
resource "aws_security_group" "http_and_all_egress" {
  name        = "HTTP-and-all-egress-group"
  description = "Used in the terraform"

  vpc_id = "${aws_vpc.main.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ensure the VPC has an Internet gateway or this step will fail
  depends_on = ["aws_internet_gateway.main"]
}

resource "aws_elb" "web" {
  name = "WEB-ELB"

  # The same availability zone as our instance
  subnets = ["${aws_subnet.web.id}"]

  security_groups = ["${aws_security_group.http_and_all_egress.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically
  instances                   = ["${aws_instance.web.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_lb_cookie_stickiness_policy" "web" {
  name                     = "lbpolicy"
  load_balancer            = "${aws_elb.web.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

resource "aws_instance" "web" {
  count = "${var.web_server_count}"

  ami           = "${var.ami["id"]}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.main.id}"
  subnet_id     = "${aws_subnet.web.id}"

  vpc_security_group_ids = [
    "${aws_security_group.ssh_http_and_all_egress.id}",
  ]

  tags {
    Name = "elb-example"
  }
  
  connection {
    type = "ssh"
    user = "${var.ami["user"]}"
    private_key  = "${file(var.key_pair["private_path"])}"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd",
      "sudo yum -y install php",
    ]
  }

  provisioner "file" {
    source      = "./files/index.php"
    destination = "/home/${var.ami["user"]}/index.php"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/${var.ami["user"]}/index.php /var/www/html/index.php",
      "sudo systemctl start httpd.service",
      "sudo systemctl enable httpd.service",
      "sudo semanage fcontext -a -t httpd_sys_script_exec_t '/var/www/html(/.*)?'",
      "sudo restorecon -R -v /var/www/html/",
    ]
  }
}

output "address" {
  value = "${aws_elb.web.dns_name}"
}

output "web_private_ips" {
  value = "${aws_instance.web.*.private_ip}"
}

output "web_public_ips" {
  value = "${aws_instance.web.*.public_ip}"
}

output "test_command" {
  value = "wget ${aws_elb.web.dns_name} 2>/dev/null ; cat index.html | grep served ; rm index.html"
}
