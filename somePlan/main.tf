provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      DeployEnv = "dev"
      AppName   = "myCoolApp"
    }
  }
}

data "aws_ami" "ubuntu_latest" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  most_recent = true
  owners      = ["099720109477"] # 099720109477 is Canonical
}

## the VPC subnets tagged as with Type value of "Private"
data "aws_subnets" "private_subnets" {
  # vpc_id = "vpc-0abc123de456fghij" # replace with your VPC ID
  tags = { Type = "Private" }
}

## get randomized list of private subnet IDs
resource "random_shuffle" "some_private_subnet_ids" {
  input = data.aws_subnets.private_subnets.ids
  # result_count = 1
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = var.instance_type
  # associate_public_ip_address = false
  subnet_id = random_shuffle.some_private_subnet_ids.result[0]
  tags      = { otherHotTag = "", Name = var.instance_name }
}