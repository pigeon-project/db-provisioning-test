output "vpc_network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.main.name
}

output "primary_instance_name" {
  description = "Cloud SQL primary instance name"
  value       = google_sql_database_instance.primary.name
}

output "primary_connection_name" {
  description = "Cloud SQL primary connection name (PROJECT:REGION:INSTANCE)"
  value       = google_sql_database_instance.primary.connection_name
}

output "replica_instance_names" {
  description = "Names of created read replica instances"
  value       = [for r in google_sql_database_instance.replica : r.name]
}

