locals {
  pg_flags = [
    {
      name  = "max_connections"
      value = tostring(var.db_max_connections)
    }
  ]
}

resource "google_sql_database_instance" "primary" {
  name             = var.db_instance_name
  database_version = var.db_version
  region           = var.region

  depends_on = [
    google_project_service.sqladmin,
    google_service_networking_connection.private_vpc_connection,
  ]

  settings {
    tier              = var.db_tier
    availability_type = var.db_availability_type

    disk_type       = "PD_SSD"
    disk_size       = var.db_disk_size_gb
    disk_autoresize = var.db_disk_autoresize

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.self_link
    }

    backup_configuration {
      enabled                        = true
      start_time                     = var.db_backup_start_time
      point_in_time_recovery_enabled = var.db_enable_pitr

      backup_retention_settings {
        retained_backups = var.db_retained_backups
        retention_unit   = "COUNT"
      }
    }

    dynamic "database_flags" {
      for_each = { for f in local.pg_flags : f.name => f }
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }
  }
}

resource "google_sql_database_instance" "replica" {
  count = var.create_read_replica ? 1 : 0

  name                  = var.db_replica_name
  region                = var.region
  database_version      = var.db_version
  master_instance_name  = google_sql_database_instance.primary.name

  # For replicas, availability_type is typically ZONAL; omit settings not required.
  depends_on = [
    google_sql_database_instance.primary,
  ]
}

