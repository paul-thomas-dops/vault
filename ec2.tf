resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated-key" {
  key_name   = "vault"
  public_key = tls_private_key.generated.public_key_openssh

  tags = merge(local.tags, { Name = "vault-key-pair" })
}

resource "aws_instance" "vault-instance" {
  ami                         = var.aws_linux_ami
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.generated-key.key_name
  vpc_security_group_ids      = [aws_security_group.vault-sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.vault-instance-profile.name
  associate_public_ip_address = true
  user_data                   = data.template_cloudinit_config.vault-cloudinit.rendered

  tags = merge(local.tags, { Name = "vault-instance" })
}
