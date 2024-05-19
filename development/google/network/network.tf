resource "google_compute_network" "main_vpc_001" {
  name                                          = "main-vpc-001"
  description                                   = "Main vpc network dedicated to development environment"
  auto_create_subnetworks                       = false
  network_firewall_policy_enforcement_order     = "BEFORE_CLASSIC_FIREWALL"
}

resource "google_compute_firewall" "main_vpc_firewall" {
  name          = "main-vpc-firewall"
  network       = google_compute_network.main_vpc_001.name
  source_tags   = ["web"]

  log_config {
    metadata  = "INCLUDE_ALL_METADATA"
  }
  allow {
    protocol  = "tcp"
    ports     = ["80", "8080", "1000-4000"]
  }
}

resource "google_compute_subnetwork" "southamerica_east1_subnet_001" {
  name            = "southamerica-east1-subnet-001"
  ip_cidr_range   = "10.2.0.0/24"
  region          = "southamerica-east1"
  network         = google_compute_network.main_vpc_001.id

  log_config  {
    aggregation_interval  = "INTERVAL_10_MIN"
    flow_sampling         = 1
    metadata              = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "southamerica_west1_subnet_001" {
  name            = "southamerica-west1-subnet-001"
  ip_cidr_range   = "10.3.0.0/24"
  region          = "southamerica-west1"
  network         = google_compute_network.main_vpc_001.id

  log_config  {
    aggregation_interval  = "INTERVAL_10_MIN"
    flow_sampling         = 1
    metadata              = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "us_east1_subnet_001" {
  name            = "us-east1-subnet-001"
  ip_cidr_range   = "10.4.0.0/24"
  region          = "us-east1"
  network         = google_compute_network.main_vpc_001.id

  log_config  {
    aggregation_interval  = "INTERVAL_10_MIN"
    flow_sampling         = 1
    metadata              = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "us_central1_subnet_001" {
  name            = "us-central1-subnet-001"
  ip_cidr_range   = "10.5.0.0/24"
  region          = "us-central1"
  network         = google_compute_network.main_vpc_001.id

  log_config  {
    aggregation_interval  = "INTERVAL_10_MIN"
    flow_sampling         = 1
    metadata              = "INCLUDE_ALL_METADATA"
  }
}
