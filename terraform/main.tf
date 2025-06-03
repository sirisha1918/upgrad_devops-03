provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "logix-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "logix-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

resource "google_container_cluster" "primary" {
  name               = "logix-gke"
  location           = var.region
  remove_default_node_pool = true
  initial_node_count = 1
  network            = google_compute_network.vpc_network.name
  subnetwork         = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = var.region
  name       = "default-node-pool"
  node_count = 2

  node_config {
    machine_type = "e2-medium"
  }
}

resource "google_artifact_registry_repository" "app_repo" {
  provider = google
  location     = var.region
  repository_id = "logix-repo"
  format       = "DOCKER"
}

resource "google_cloud_run_service" "stub" {
  name     = "logix-cloudrun"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

