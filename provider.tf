terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}

provider "azurerm" {
  subscription_id = var.sub_id
  features {}
}

provider "google" {
  project     = var.project_id
  region      = var.gcp_region
  credentials = var.cred
}

