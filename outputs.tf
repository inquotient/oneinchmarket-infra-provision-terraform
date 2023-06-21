output "output_vpcname" {
    value = module.vpc.output_vpcname
}

output "output_vpc_cidr_block" {
    value = module.vpc.output_vpc_cidr_block
}

output "output_igwname" {
    value = module.vpc.output_igwname
}

output "output_rtname" {
    value = module.vpc.output_rtname
}

output "output_private_subnet_name" {
    value = module.vpc.output_private_subnet_name
}

output "output_ngwname" {
    value = module.vpc.output_ngwname
}

output "output_public_subnets" {
    value = module.vpc.output_public_subnets
}

output "output_private_subnets" {
    value = module.vpc.output_private_subnets
}

output "output_s3_bucket_id" {
    value = module.s3_bucket.output_s3_bucket_id
}

output "output_s3_bucket_bucket_domain_name" {
    value = module.s3_bucket.output_s3_bucket_bucket_domain_name
}

output "output_ssh_public_key" {
    value = module.key_pair.output_ssh_public_key
}

output "output_ssh_private_key" {
    value = module.key_pair.output_ssh_private_key
    sensitive = true
}

output "output_s3_domain_name" {
    value = module.s3_bucket.output_s3_domain_name
}
# output "output_aws_access_key_id" {
#     value = var.aws_access_key_id
# }
# 
# output "output_aws_access_key_secret" {
#     value = var.aws_access_key_secret
# }