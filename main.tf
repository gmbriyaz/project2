provider "google" {
  project = "moonlight-infra"
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "moonlight"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "moonlight-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_network.self_link
  region        = "us-central1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "moonlight-dev"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240808"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      // Ephemeral IP
    }
  }
}
