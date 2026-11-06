resource "google_compute_network" "lab" {
  name                    = "${var.resource_prefix}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lab" {
  name          = "${var.resource_prefix}-subnet"
  ip_cidr_range = "10.30.1.0/24"
  region        = var.region
  network       = google_compute_network.lab.id
}

resource "google_compute_address" "lab" {
  name   = "${var.resource_prefix}-ip"
  region = var.region
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.resource_prefix}-allow-ssh"
  network = google_compute_network.lab.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.ssh_source_cidr]
}

resource "google_compute_firewall" "allow_http" {
  name    = "${var.resource_prefix}-allow-http"
  network = google_compute_network.lab.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "lab" {
  name         = "${var.resource_prefix}-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 32
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lab.id
    access_config {
      nat_ip = google_compute_address.lab.address
    }
  }

  metadata = {
    ssh-keys = "${var.admin_username}:${trimspace(file(pathexpand(var.ssh_public_key_path)))}"
    user-data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
      k3s_version = var.k3s_version
    })
    startup-script = <<-EOT
      #!/bin/bash
      set -eu
      if ! command -v k3s >/dev/null 2>&1; then
        curl -fsSL https://get.k3s.io -o /tmp/install-k3s.sh
        INSTALL_K3S_VERSION='${var.k3s_version}' sh /tmp/install-k3s.sh
      fi
    EOT
  }

  depends_on = [
    google_compute_firewall.allow_ssh,
    google_compute_firewall.allow_http
  ]
}
