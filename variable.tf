variable "region" {
  default = "eu-west-2"
}

variable "aws_linux_ami" {
  description = "ami for vault ec2 instance"
  default     = "ami-02f5781cba46a5e8a"
}

variable "vault_ip_name" {
  default = "egp-vault-eip"
}

variable "ssh_keys" {
}

variable "ingress_blocks" {
  description = "ip whitelist for vault access"
}

variable "instance_connect_addresses" {
  description = "needed to connect via aws console (optional)"
}

variable "egress_blocks" {
  description = "ip whitelist for vault egress"
}
