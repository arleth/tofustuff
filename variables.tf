# VelPharma Infrastructure Variables

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "velpdevdb"
}

variable "db_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "changeme"
  sensitive   = true
}

variable "db_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5434
}

variable "project_name" {
  description = "Project name for labeling"
  type        = string
  default     = "velpharma"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}
