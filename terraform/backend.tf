terraform {
  backend "gcs" {
    bucket  = "logix-terraform-state01"
    prefix  = "terraform/state"
  }
}

