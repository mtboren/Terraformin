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

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = ">= 6.0.0"
  name                 = "my-cool-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_tags = { Type = "Private" }
  public_subnets       = ["10.0.101.0/24"]
  public_subnet_tags = { Type = "Public" }
  enable_dns_hostnames = true
}

## the VPC subnets tagged as with Type value of "Private" (was useful for getting existing private subnets, but not really needed now, since we added new VPC via module, and get the private subnets' IDs via `module.vpc.private_subnets`)
data "aws_subnets" "private_subnets" {
  # vpc_id = "vpc-0abc123de456fghij" # replace with your VPC ID
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = { Type = "Private" }
}

## get randomized list of private subnet IDs
resource "random_shuffle" "some_private_subnet_ids" {
  # input = data.aws_subnets.private_subnets.ids ## when getting existing private subnets, for example
  input = module.vpc.private_subnets ## when using private subnets from VPC module
  # result_count = 1
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = var.instance_type
  # associate_public_ip_address = false
  subnet_id = random_shuffle.some_private_subnet_ids.result[0]
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  tags      = { otherHotTag = "", Name = var.instance_name }
}