provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_files  = ["/home/ahnjisoo/.aws/credentials"]
    profile = "default"
}

resource "aws_eip" "openvpn" {
    tags = {
        "Name" = "${var.appname}-openvpn"
        "Project" = "openvpn"
    }
}

resource "aws_eip_association" "openvpn" {
    instance_id   = module.bastion.id
    allocation_id = aws_eip.openvpn.id
}

locals {
    openvpn_userdata = templatefile("${path.module}/files/openvpn-userdata.sh", {
        vpc_cidr  = var.public_subnets_cidr_blocks[0]
        public_ip = aws_eip.openvpn.public_ip
        ssh_private_key = var.ssh_private_key
    })
    common_tags = {
        "Project" = "openvpn"
    }
}

module "bastion" {
    source  = "terraform-aws-modules/ec2-instance/aws"

    name = var.bastion_name

#    user_data = local.openvpn_userdata
    
    ami = "ami-0252e942f644326f7"
    instance_type          = "t2.small"
    key_name               = "${var.key_name}"
    monitoring             = false
    vpc_security_group_ids = [var.bastion_sg_id]
    subnet_id              = var.public_subnets[0]

    tags = {
        Terraform   = "true"
        Environment = "${var.environment}"
    }
}