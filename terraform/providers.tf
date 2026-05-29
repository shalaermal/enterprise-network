terraform {
  required_providers {
    netbox = {
      source  = "smutel/netbox"
      version = "~> 7.0"
    }
  }
}

provider "netbox" {
  url    = "81.17.100.252:8000"
  token  = var.netbox_token
  scheme = "http"
}