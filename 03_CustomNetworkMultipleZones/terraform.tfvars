region = "us-east-1"

key_pair = {
  name         = "main_key_pair"
  private_path = "./key/id_rsa"
  public_path  = "./key/id_rsa.pub"
}

vpc = {
  name = "03_networking_main_VPC"
  cidr_block = "10.0.0.0/16"
}

subnets = [
  {
    name = "subnet1"
    az   = "us-east-1a"
    cidr = "10.0.0.0/24"
  },
  {
    name = "subnet2"
    az   = "us-east-1c"
    cidr = "10.0.1.0/24"
  },
]

ami = {
 # id   =  "ami-0ac019f4fcb7cb7e6" # Ubuntu 18.04, 
 # user = ubuntu
  id   = "ami-011b3ccf1bd6db744" # RHEL, login: ec2-user 
  user = "ec2-user"
}

server_one = {
  name          = "server_one", 
  instance_type = "t2.micro",
  private_ip    = "10.0.0.10"
}

server_two = {
  name          = "server_two", 
  instance_type = "t2.micro",
  private_ip    = "10.0.1.10"
}
