provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_files  = ["/home/ahnjisoo/.aws/credentials"]
    profile = "default"
}

resource "tls_private_key" "this" {
    algorithm = "RSA"
}

module "key_pair" {
    source = "terraform-aws-modules/key-pair/aws"

    key_name   = "${var.key_name}"
    public_key = trimspace(tls_private_key.this.public_key_openssh)
}

resource "local_file" "ssh_private_key" {
    filename = "${var.key_name}.pem"
    content = tls_private_key.this.private_key_pem
}

resource "local_file" "ssh_public_key" {
    filename = "${var.key_name}.pub"
    content = tls_private_key.this.public_key_openssh
}