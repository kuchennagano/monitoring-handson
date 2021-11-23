# VPCの作成
resource "google_compute_network" "vpc_network" {
  name                    = "${local.prefix}-network"
  auto_create_subnetworks = false
}

# サブネットの作成
resource "google_compute_subnetwork" "vpc_network_subnet" {
  name          = "${local.prefix}-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_network.id
}

# CloudRouterの作成(CloudNAT作成のため)
resource "google_compute_router" "router" {
  project = local.project
  name    = "${local.prefix}-router"
  network = google_compute_network.vpc_network.name
  region  = local.region
}

# CloudNATの作成(プライベートサブネットからのインターネット接続のため)
resource "google_compute_router_nat" "nat" {
  name                               = "${local.prefix}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
