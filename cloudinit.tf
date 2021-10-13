data "template_file" "add-user-keys" {
  for_each = var.ssh_keys

  template = file("./userdata/add_user_public_keys.sh")

  vars = {
    ssh_key = each.value.key
  }
}

data "template_file" "associate-elastic-ip-address" {
  template = file("./userdata/associate_elastic_ip_address.sh")
  vars = {
    vault_ip_id = data.aws_eip.vault_ip.id
    region      = var.region
  }
}

data "template_file" "install-vault" {
  template = file("./userdata/install_vault.sh")
}

data "template_cloudinit_config" "vault-cloudinit" {
  gzip          = true
  base64_encode = true
  dynamic part {
    for_each = data.template_file.add-user-keys
    content {
      filename     = "add-keys.sh"
      content_type = "text/x-shellscript"
      content      = part.value.rendered
    }
  }

  part {
    filename     = "associate-keys.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.associate-elastic-ip-address.rendered
  }

  part {
    filename     = "install_vault.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.install-vault.rendered
  }
}
