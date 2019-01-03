provider "aws" {
  version = "~> 1.54"
  region = "us-east-1"
}

# ----------------------------------------------------------------------------
# Question       : What's the effect of searching for the latest AMI on the instance resource block below?
# Answer         : ___________________________________________________________
# Conclusion     : Only use this for your cattle!
# Question       : Could it cause any problems?
# Answer         : ___________________________________________________________
# Conclusion     : Be careful when constructing these filters.
# ----------------------------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's ID
}

# ----------------------------------------------------------------------------
# Question       : How can you connect to this instance?
# Answer         : ___________________________________________________________
# Question       : Do we miss something?
# Answer         : ___________________________________________________________
# Conclusion     : It's not possible to connect to this instance.
# ----------------------------------------------------------------------------
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  
  tags {
    Name = "Latest Ubuntu 18.04 Server" # Yes, this tag starts with a capital letter N.
  }
}

output "image_id" {
  value = "${data.aws_ami.ubuntu.id}"
}
