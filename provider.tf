terraform {
  required_version = "1.0.10"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0.0"
    }
  }

  backend "gcs" {
    bucket = "ca-nagano-taichi-test" #各自のGCSに変更
    prefix = "terraform/state"
  }
}

provider "google" {
  project = local.project
  region  = local.region
}



