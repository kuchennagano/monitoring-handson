# メンテナンスSSH(IAP接続)用のファイアーウォールルール作成
resource "google_compute_firewall" "allow-ssh-iap" {
  name          = "allow-iap-ssh-from-mainte"
  network       = google_compute_network.vpc_network.name
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["monitoring-server"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# VPC内通信用ファイアウォールルール作成
resource "google_compute_firewall" "allow-internal" {
  name          = "allow-internal"
  network       = google_compute_network.vpc_network.name
  priority      = 65534
  direction     = "INGRESS"
  source_ranges = [google_compute_subnetwork.vpc_network_subnet.ip_cidr_range] #サブネット内
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
}
