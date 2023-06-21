provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_files  = ["/home/ahnjisoo/.aws/credentials"]
    profile = "default"
}

module "ec2_kops" {
    source  = "terraform-aws-modules/ec2-instance/aws"

    count = 2
    name = "ec2_kops-${count.index}"
    
    ami = "ami-0c9c942bd7bf113a2"
    instance_type          = "t3.medium"
    key_name               = "${var.key_name}"
    monitoring             = false
    vpc_security_group_ids = [var.bastion_sg_id]
    subnet_id              = var.private_subnets[0]

    tags = {
        Terraform   = "true"
        Environment = "${var.environment}"
    }

    depends_on = [
        var.key_name
    ]
}