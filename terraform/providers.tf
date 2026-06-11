terraform {
  required_version = ">= 1.0"
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 3.0"
    }
  }
}

provider "netbox" {
  server_url = "http://81.17.100.252:8000"
  api_token  = var.netbox_token
}