variable "project_id" {
  description = "GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "Primary region for all resources"
  type        = string
  default     = "europe-central2"
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "main-vpc"
}

variable "subnet_cidr" {
  description = "CIDR for the primary subnet"
  type        = string
  default     = "10.10.0.0/16"
}

variable "db_instance_name" {
  description = "Cloud SQL primary instance name"
  type        = string
  default     = "kanban-db"
}

variable "database_name" {
  description = "Initial database name to create in the instance"
  type        = string
  default     = "kanban"
}

variable "db_tier" {
  description = "Cloud SQL machine tier (e.g., db-custom-2-8192 for 2 vCPU, 8 GB RAM)"
  type        = string
  default     = "db-custom-2-8192"
}

variable "db_disk_size_gb" {
  description = "Disk size for the Cloud SQL instance in GB"
  type        = number
  default     = 150
}

variable "db_disk_type" {
  description = "Disk type for the Cloud SQL instance (PD_SSD or PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "db_ha" {
  description = "Enable Regional (HA) availability for primary instance"
  type        = bool
  default     = true
}

variable "enable_pitr" {
  description = "Enable Point-in-Time Recovery (PITR)"
  type        = bool
  default     = true
}

variable "backup_retained_backups" {
  description = "Number of automated backups to retain"
  type        = number
  default     = 35
}

variable "max_connections" {
  description = "PostgreSQL max_connections setting"
  type        = number
  default     = 500
}

variable "read_replica_count" {
  description = "Number of read replicas to create"
  type        = number
  default     = 1
}

