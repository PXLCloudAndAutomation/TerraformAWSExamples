provider "aws" {
  region = "${var.region}"
}

provider "null" {
  version = "~> 1.0"
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

resource "aws_instance" "haproxy_load_balancer" {
  ami = "${var.ami["id"]}"
    instance_type = "${var.instance_type}"
    key_name = "${aws_key_pair.main.key_name}"
  subnet_id     = "${aws_subnet.web.id}"

  vpc_security_group_ids = ["${aws_security_group.ssh_http_and_all_egress.id}"]

    connection {
        type = "ssh"
        user = "${var.ami["user"]}"
        private_key  = "${file(var.key_pair["private_path"])}"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo yum install -y haproxy",
      ]
    }
}

resource "aws_instance" "web" {
  count = "${var.web_server_count}"

  ami = "${var.ami["id"]}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.main.key_name}"
  subnet_id     = "${aws_subnet.web.id}"
  
  vpc_security_group_ids = ["${aws_security_group.ssh_http_and_all_egress.id}"]
  
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

resource "null_resource" "after_web_server" {
  depends_on = ["aws_instance.web"]

  triggers {
    haproxy        = "${aws_instance.haproxy_load_balancer.id}"
    webservers     = "${join(":", aws_instance.web.*.id)}"
    webservers_ips = "${join(":", aws_instance.web.*.private_ip)}"
  }

	provisioner "local-exec" {
    command = "echo '${join(":", aws_instance.web.*.private_ip)}' > private_ips.txt"
  }

  # Generate the correct hosts file and ha proxy file.
  # Unfortunately Terraform null_resource has no inline for local-exec
  # Let's use a Python2 script.
	provisioner "local-exec" {
    command = "./gen_haproxy_and_hosts_files.py ${aws_instance.haproxy_load_balancer.id} local ${join(":", aws_instance.web.*.private_ip)}"
  }

  connection {
    type = "ssh"
    host = "${aws_instance.haproxy_load_balancer.public_ip}"
    user = "${var.ami["user"]}"
    private_key  = "${file(var.key_pair["private_path"])}"
  }

  provisioner "file" {
    source      = "./files/hosts"
    destination = "/home/${var.ami["user"]}/hosts"
  }

  provisioner "file" {
    source      = "./files/haproxy.cfg"
    destination = "/home/${var.ami["user"]}/haproxy.cfg"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/${var.ami["user"]}/hosts /etc/hosts",
      "sudo mv /home/${var.ami["user"]}/haproxy.cfg /etc/haproxy/haproxy.cfg",
      "sudo semanage permissive -a haproxy_t",
      "sudo systemctl restart haproxy",
    ]
  }
}

output "test_command" {
  value = "wget ${aws_instance.haproxy_load_balancer.public_ip} 2>/dev/null ; cat index.html | grep served ; rm index.html"
}
