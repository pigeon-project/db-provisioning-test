locals {
  availability_type = var.db_ha ? "REGIONAL" : "ZONAL"
}

resource "google_sql_database_instance" "primary" {
  name             = var.db_instance_name
  database_version = "POSTGRES_16"
  region           = var.region

  settings {
    tier              = var.db_tier
    availability_type = local.availability_type
    disk_type         = var.db_disk_type
    disk_size         = var.db_disk_size_gb
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.id
      require_ssl     = true
    }

    backup_configuration {
      enabled                         = true
      point_in_time_recovery_enabled  = var.enable_pitr

      backup_retention_settings {
        retained_backups = var.backup_retained_backups
        retention_unit   = "COUNT"
      }
    }

    database_flags {
      name  = "max_connections"
      value = tostring(var.max_connections)
    }
  }

  deletion_protection = true

  depends_on = [
    google_service_networking_connection.private_vpc_connection,
    google_project_service.sqladmin
  ]
}

resource "google_sql_database" "app" {
  name     = var.database_name
  instance = google_sql_database_instance.primary.name
}

resource "google_sql_database_instance" "replica" {
  count            = var.read_replica_count
  name             = "${var.db_instance_name}-rr-${count.index + 1}"
  database_version = "POSTGRES_16"
  region           = var.region

  master_instance_name = google_sql_database_instance.primary.name

  settings {
    tier            = var.db_tier
    disk_type       = var.db_disk_type
    disk_size       = var.db_disk_size_gb
    disk_autoresize = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.id
      require_ssl     = true
    }
  }

  depends_on = [google_sql_database_instance.primary]
}

