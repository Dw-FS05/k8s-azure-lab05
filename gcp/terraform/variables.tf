variable "project_id" {
  type        = string
  description = "Identificador del proyecto en Google Cloud (Project ID)."
}

variable "region" {
  type        = string
  description = "Region de GCP para el despliegue."
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zona de disponibilidad en GCP."
  default     = "us-central1-a"
}

variable "resource_prefix" {
  type        = string
  description = "Prefijo para los nombres de los recursos."
  default     = "devops-k3s"
}

variable "machine_type" {
  type        = string
  description = "Tipo de maquina en Compute Engine (2 vCPU, 4GB RAM)."
  default     = "e2-medium"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Nombre de usuario para conexion SSH a la VM."
}

variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
  description = "Ruta de la clave SSH publica local."
}

variable "ssh_source_cidr" {
  type        = string
  description = "IPv4 publica del estudiante con mascara /32."
}

variable "k3s_version" {
  type        = string
  description = "Version de K3s fijada para la practica."
  default     = "v1.35.2+k3s1"
}
