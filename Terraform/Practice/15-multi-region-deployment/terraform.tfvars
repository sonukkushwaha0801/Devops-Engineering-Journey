primary_region           = "us-east-1"
secondary_region         = "us-west-2"
environment              = "production"
primary_instance_count   = 2
secondary_instance_count = 1
instance_type            = "t3.micro"
rds_instance_class       = "db.t3.micro"
domain_name              = "app.example.com"
db_name                  = "appdb"
# WARNING: Do not commit real passwords!
# Use: export TF_VAR_db_password="your-secure-password"
db_username = "admin"
