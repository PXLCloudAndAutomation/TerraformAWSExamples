region = "us-east-1"

vpc = {
  name = "07_RelationalDatabaseService_main_VPC"
  cidr_block = "10.0.0.0/16"
}

subnet_1 = {
  cidr = "10.0.1.0/24"
  az   = "us-east-1b"
  name = "main_subnet_1"
}

subnet_2 = {
  cidr = "10.0.2.0/24"
  az   = "us-east-1c"
  name = "main_subnet_2"
}

security_group = {
  name          = "main_rds_sg"
  incoming_cidr = "0.0.0.0/0"
}


engine = "postgres"
engine_version = {
    mysql    = "5.7.21"
    postgres = "9.6.8"
}

instance_class = "db.t2.micro"

identifier = "mydb-rds"
storage    = "10"
db_name    = "mydb"
username   = "mydbuser"
password   = "QjgfGquc5elBcRtDyOwBQW3PdM9TKrOlle"
