# 変数定義
locals {
  machine_type = "f1-micro"
  image-name   = "tnagano-terraform-image-ubuntu2004-2021-11-24t23-38-37z" #変更
  zone         = "asia-northeast1-a"
}

# Service Account
resource "google_service_account" "monitoring_gce_sa" {
  account_id   = "monitoring-gce"
  display_name = "monitoring-gce"
  description  = "A service account for monitoring_gce"
}

# IAM Role binding
resource "google_project_iam_member" "monitoring_gce_sa_roles" {
  project = local.project
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer"
  ])
  role   = each.value
  member = "serviceAccount:${google_service_account.monitoring_gce_sa.email}"
}

# Create GCE
resource "google_compute_instance" "monitoring_gce" {
  name         = "${local.prefix}-instance"
  machine_type = local.machine_type
  zone         = local.zone

  tags = ["monitoring-server"]

  boot_disk {
    initialize_params {
      image = local.image-name
      size  = "20"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_network_subnet.name
  }

  service_account {
    email  = google_service_account.monitoring_gce_sa.email
    scopes = ["cloud-platform"]
  }
}
