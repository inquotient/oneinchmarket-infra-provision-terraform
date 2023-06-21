provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_files  = ["/home/ahnjisoo/.aws/credentials"]
    profile = "default"
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "${var.appname}"

    instance_tenancy = "default"

    azs = ["ap-northeast-2a", "ap-northeast-2b"]

    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

    enable_nat_gateway = true
#    enable_vpn_gateway = true

    tags = {
        Terraform = "true"
        Environment = "${var.environment}"
    }
}

resource "aws_network_acl" "private_nacl" {
  vpc_id = module.vpc.vpc_id

  count = 1
  
  egress {
    protocol   = "tcp"
    rule_no    = (count.index + 1) * 100
    action     = "allow"
    cidr_block = "10.0.1.0/24"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = (count.index + 1) * 200
    action     = "allow"
    cidr_block = "10.0.2.0/24"
    from_port  = 80
    to_port    = 80
  }
}