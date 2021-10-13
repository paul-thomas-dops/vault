resource "aws_security_group" "vault-sg" {
  name   = "vault-access-security-group"
  vpc_id = module.vpc.vpc_id

  tags = merge(local.tags, { Name = "vault-access-security-group" })
}

resource "aws_security_group_rule" "vault_ingress_ssh" {
  for_each = var.ingress_blocks

  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [each.value["cidr"]]
  description       = "SSH - ${each.key}"
  security_group_id = aws_security_group.vault-sg.id
}

resource "aws_security_group_rule" "vault_ingress_ssh_ec2_instance_connect" {
  for_each = var.instance_connect_addresses

  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [each.value["cidr"]]
  description       = "SSH - EC2 Instance Connect ${each.key}"
  security_group_id = aws_security_group.vault-sg.id
}

resource "aws_security_group_rule" "vault_ingress_http" {
  for_each = var.ingress_blocks

  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = [each.value["cidr"]]
  description       = "HTTP - ${each.key}"
  security_group_id = aws_security_group.vault-sg.id
}

resource "aws_security_group_rule" "vault_onward_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  self              = true
  description       = "onward HTTP from this group"
  security_group_id = aws_security_group.vault-sg.id
}

resource "aws_security_group_rule" "vault_ingress_https" {
  for_each = var.ingress_blocks

  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [each.value["cidr"]]
  description       = "HTTPS - ${each.key}"
  security_group_id = aws_security_group.vault-sg.id
}

resource "aws_security_group_rule" "vault_onward_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  self              = true
  description       = "onward HTTPS from this group"
  security_group_id = aws_security_group.vault-sg.id
}

resource "aws_security_group_rule" "vault_egress" {
  type              = "egress"
  protocol          = -1
  from_port         = 0
  to_port           = 0
  cidr_blocks       = var.egress_blocks
  security_group_id = aws_security_group.vault-sg.id
}
