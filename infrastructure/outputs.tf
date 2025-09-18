output "network_id" {
  description = "VPC network ID"
  value       = google_compute_network.main.id
}

output "subnetwork_id" {
  description = "Subnetwork ID"
  value       = google_compute_subnetwork.main.id
}

output "sql_primary_connection_name" {
  description = "Connection name for primary Cloud SQL instance"
  value       = google_sql_database_instance.primary.connection_name
}

output "sql_primary_private_ip" {
  description = "Private IP of the primary Cloud SQL instance"
  value = try(
    one([for ip in google_sql_database_instance.primary.ip_address : ip.ip_address if ip.type == "PRIVATE"]),
    null
  )
}

output "sql_replica_connection_name" {
  description = "Connection name for replica instance (if created)"
  value       = try(google_sql_database_instance.replica[0].connection_name, null)
}

