provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_files  = ["/home/ahnjisoo/.aws/credentials"]
    profile = "default"
}

module "bastion_sg" {
    source = "terraform-aws-modules/security-group/aws"

    name = "${var.appname}-bastion-sg"
    description = "Security group for oneInchMarket"

    vpc_id = var.vpc_id

    ingress_with_cidr_blocks = [
        {
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            description = "ssh port"
            cidr_blocks = "0.0.0.0/0"
        },
        {
            from_port   = 1194
            to_port     = 1194
            protocol    = "udp"
            description = "openVPN port"
            cidr_blocks = "0.0.0.0/0"
        },
        {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            description = "openVPN port"
            cidr_blocks = "0.0.0.0/0"
        },
        {
            from_port   = 943
            to_port     = 943
            protocol    = "tcp"
            description = "openVPN port"
            cidr_blocks = "0.0.0.0/0"
        },
        {
            from_port   = 945
            to_port     = 945
            protocol    = "tcp"
            description = "openVPN port"
            cidr_blocks = "0.0.0.0/0"
        },
    ]

    egress_with_cidr_blocks = [
        {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        description = "all"
        cidr_blocks = "0.0.0.0/0"
        }
    ]
}