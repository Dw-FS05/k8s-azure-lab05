output "public_ip" {
  description = "Direccion IPv4 publica de la VM."
  value       = google_compute_address.lab.address
}

output "ssh_command" {
  description = "Comando de acceso SSH valido."
  value       = "ssh ${var.admin_username}@${google_compute_address.lab.address}"
}

output "instance_name" {
  description = "Nombre de la instancia de Compute Engine."
  value       = google_compute_instance.lab.name
}

output "network_name" {
  description = "Nombre de la red VPC creada."
  value       = google_compute_network.lab.name
}
