terraform {
  required_version = ">= 1.0"
}

output "server_ip" {
  value       = "81.17.100.252"
  description = "EVE-NG Server IP Address"
}

output "eve_ng_web" {
  value       = "http://81.17.100.252"
  description = "EVE-NG Web Interface URL"
}

output "ssh_command" {
  value       = "ssh root@81.17.100.252"
  description = "SSH connection command"
}