output "output_key_name" {
    value = "${var.key_name}"
}

output "output_key_file_name" {
    value = local_file.ssh_private_key.filename
}

output "output_ssh_public_key" {
    value = trimspace(tls_private_key.this.public_key_openssh)
}

output "output_ssh_private_key" {
    value = trimspace(tls_private_key.this.private_key_pem)
}