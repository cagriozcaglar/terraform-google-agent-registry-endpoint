# This file specifies the required provider and version for this module.
terraform {
  # Specifies the required provider and its version constraints.
  required_providers {
    # The Google Cloud provider is used to manage and provision GCP resources.
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50.0"
    }
  }
}
