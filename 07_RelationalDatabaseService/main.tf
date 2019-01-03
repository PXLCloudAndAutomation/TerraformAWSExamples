provider "aws" {
  version = "~> 1.54"
  region = "${var.region}"
}

resource "aws_db_instance" "service" {
  depends_on             = ["aws_security_group.main"]
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  engine                 = "${var.engine}"
  engine_version         = "${lookup(var.engine_version, var.engine)}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.db_name}"
  username               = "${var.username}"
  password               = "${var.password}"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.main.id}"
  publicly_accessible    = true
  
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "main" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = ["${aws_subnet.subnet_1.id}", "${aws_subnet.subnet_2.id}"]
}

output "db_endpoint" {
  value = "${aws_db_instance.service.endpoint}"
}

output "test_command" {
  value = "./test_db.py ${aws_db_instance.service.address} ${var.db_name} ${var.username} ${var.password}"
}
