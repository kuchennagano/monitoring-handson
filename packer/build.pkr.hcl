build {
  sources = ["source.googlecompute.monitoring-image"]

  provisioner "ansible" {
    groups        = var.groups
    playbook_file = var.playbook_file
    user          = var.ssh_username
  }

}
