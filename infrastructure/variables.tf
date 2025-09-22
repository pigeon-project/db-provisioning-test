variable "project_id" {
  description = "GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "Primary region for resources"
  type        = string
  default     = "europe-central2"
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "kanban-vpc"
}

variable "subnet_name" {
  description = "Name of the regional subnetwork"
  type        = string
  default     = "kanban-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnetwork"
  type        = string
  default     = "10.10.0.0/16"
}

variable "psc_range_name" {
  description = "Name for the private service connection (VPC peering) allocated range"
  type        = string
  default     = "kanban-psc-range"
}

variable "db_instance_name" {
  description = "Name of the primary Cloud SQL instance"
  type        = string
  default     = "kanban-postgres"
}

variable "db_replica_name" {
  description = "Name of the read replica Cloud SQL instance"
  type        = string
  default     = "kanban-postgres-replica"
}

variable "db_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "POSTGRES_16"
}

variable "db_tier" {
  description = "Cloud SQL machine tier (e.g., db-custom-2-8192 ~ 2 vCPU, 8GB)"
  type        = string
  default     = "db-custom-2-8192"
}

variable "db_disk_size_gb" {
  description = "Disk size in GB for Cloud SQL instance"
  type        = number
  default     = 150
}

variable "db_disk_autoresize" {
  description = "Whether to enable disk autoresize for Cloud SQL"
  type        = bool
  default     = true
}

variable "db_availability_type" {
  description = "Availability type for Cloud SQL (ZONAL or REGIONAL)"
  type        = string
  default     = "REGIONAL"
}

variable "db_backup_start_time" {
  description = "Start time for automated backups in HH:MM (UTC)"
  type        = string
  default     = "03:00"
}

variable "db_enable_pitr" {
  description = "Enable Point-In-Time Recovery (PITR)"
  type        = bool
  default     = true
}

variable "db_retained_backups" {
  description = "Number of retained automatic backups (for ~35 days if daily)"
  type        = number
  default     = 35
}

variable "db_max_connections" {
  description = "Target max_connections for PostgreSQL"
  type        = number
  default     = 500
}

variable "create_read_replica" {
  description = "Whether to create a read replica"
  type        = bool
  default     = true
}

