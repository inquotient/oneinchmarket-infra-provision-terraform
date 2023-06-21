module "vpc" {
    source  = "./modules/network"

    appname = "oneInchMarket"
    environment = "dev"
}

module "key_pair" {
    source = "./modules/key_pair"

    key_name = "terraform"
}

module "bastion_sg" {
    source = "./modules/sg"

    appname = "oneInchMarket"
    vpc_id = module.vpc.output_vpc_id
}

module "s3_bucket" {
    source = "./modules/s3"

    appname = "oneInchMarket"
    vpc_id = module.vpc.output_vpc_id
}

module "bastion" {
    source = "./modules/bastion"

    appname = "oneInchMarket"
    bastion_name = local.bastion_name
    environment = "dev"
    key_name = module.key_pair.output_key_name
    bastion_sg_id = module.bastion_sg.output_bastion_sg_id
    public_subnets = module.vpc.output_public_subnets
    public_subnets_cidr_blocks = module.vpc.output_public_subnets_cidr_blocks
    ssh_private_key = module.key_pair.output_ssh_private_key
}

# module "ec2_kops" {
#     source = "./modules/ec2_kops"
# 
#     appname = "oneInchMarket"
#     environment = "dev"
#     key_name = module.key_pair.output_key_name
#     bastion_sg_id = module.bastion_sg.output_bastion_sg_id
#     private_subnets = module.vpc.output_private_subnets
# }

module "registry_kops" {
    source = "./modules/registry_kops"

    appname = "oneInchMarket"
    s3_bucket_id = module.s3_bucket.output_s3_bucket_id
    s3_bucket_bucket_domain_name = module.s3_bucket.output_s3_bucket_bucket_domain_name
    key_name = module.key_pair.output_key_name
    ssh_key = module.key_pair.output_ssh_public_key
    domain_name = local.domain_name
    vpc_id = module.vpc.output_vpc_id
    vpc_cidr_block = module.vpc.output_vpc_cidr_block
    azs = module.vpc.output_azs
    private_subnets = module.vpc.output_private_subnets
    public_subnets_cidr_blocks = module.vpc.output_public_subnets_cidr_blocks
    private_subnets_cidr_blocks = module.vpc.output_private_subnets_cidr_blocks
    nat_ids = module.vpc.output_nat_ids
    aws_access_key_id = var.aws_access_key_id
    aws_access_key_secret = var.aws_access_key_secret
    private_subnet_name = module.vpc.output_private_subnet_name
}

resource "null_resource" "main_test" {
    provisioner "local-exec" {
        command = "echo main input data output test"
    }
}