Infrastructure for the Kanban application

Notes:
- Google Cloud Platform only. Region default is europe-central2.
- Creates: VPC, subnet, Private Service Access, Cloud SQL PostgreSQL 16 (HA), daily backups with PITR, 35 retained backups, and one read replica.
- Variables are defined in variables.tf; pass `-var project_id=...` at init/plan time.

Basic usage:
1. terraform init
2. terraform validate
3. terraform plan -var "project_id=YOUR_PROJECT_ID"

