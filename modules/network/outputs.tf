output "output_vpcname" {
    value = "${var.appname}-vpc"
}

output "output_vpc_cidr_block" {
    value = module.vpc.vpc_cidr_block
}

output "output_igwname" {
    value = "${var.appname}-igw"
}

output "output_rtname" {
    value = "${var.appname}-rt"
}

output "output_private_subnet_name" {
    value = "${var.appname}-private-${module.vpc.azs[0]}"
}

output "output_ngwname" {
    value = "${var.appname}-ngw"
}

output "output_vpc_id" {
    value = "${module.vpc.vpc_id}"
}

output "output_azs" {
    value = module.vpc.azs
}

output "output_public_subnets" {
    value = module.vpc.public_subnets
}

output "output_public_subnets_cidr_blocks" {
    value = module.vpc.public_subnets_cidr_blocks
}

output "output_private_subnets" {
    value = module.vpc.private_subnets
}

output "output_private_subnets_cidr_blocks" {
    value = module.vpc.private_subnets_cidr_blocks
}

output "output_nat_ids" {
    value = module.vpc.nat_ids
}