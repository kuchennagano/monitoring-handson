source "googlecompute" "monitoring-image" {
  disk_size    = var.disk_size
  image_name = "${var.image_name}-${lower(regex_replace(timestamp(), ":", "-"))}"
  network      = var.network
  project_id   = var.project_id
  scopes       = ["https://www.googleapis.com/auth/cloud-platform"]
  source_image = var.source_image
  ssh_username = var.ssh_username
  subnetwork   = var.subnetwork
  tags         = [var.tags]
  zone         = var.zone
}