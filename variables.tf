variable "budget_amount" {
  description = "Monthly spend, in dollars, which triggers an email alert"
  type        = number
  default     = "5"
}

variable "budget_alarm_email_address" {
  description = "Email address to send budget alerts to"
  type        = string
}

variable "data_volume_size" {
  description = "Size of the data volume (volume where postgres data and image files are stored)"
  type        = number
}

variable "compartment_name" {
  description = "Name of the compartment to create"
  type        = string
  default     = "immich"
}

variable "domain_name" {
  description = "Domain name to host the service at"
  type        = string
}

variable "name" {
  description = "Name of the instance to create"
  type        = string
  default     = "immich"
}

variable "ocpus" {
  description = "CPU count for instance"
  type        = number
  default     = 4
}

variable "memory_in_gbs" {
  description = "Memory for instance"
  type        = number
  default     = 12
}

variable "ssh_public_key_path" {
  description = "Path to public ssh key, e.g. ~/.ssh/id_rsa.pub"
  type        = string
}

variable "tenancy_ocid" {
  description = "OCID for the Tenancy"
  type        = string
}

variable "zone_name" {
  description = "R53 Zone Name"
  type        = string
}
