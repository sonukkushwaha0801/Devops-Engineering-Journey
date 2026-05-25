# ==========================================
# Modules: Networking
# ==========================================

module "networking" {
  source = "./modules/networking"

  environment = var.environment
  cidr_block  = var.cidr_block
  az_count    = var.az_count
}

# ==========================================
# Modules: Compute
# ==========================================

module "compute" {
  source = "./modules/compute"

  environment        = var.environment
  instance_type      = var.instance_type
  instance_count     = var.instance_count
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.subnet_ids
  security_group_ids = [module.networking.app_sg_id]
}

# ==========================================
# Modules: Database
# ==========================================

module "database" {
  source = "./modules/database"

  environment         = var.environment
  db_instance_class   = var.db_instance_class
  allocated_storage   = var.allocated_storage
  vpc_id              = module.networking.vpc_id
  subnet_ids          = module.networking.subnet_ids
  security_group_ids  = [module.networking.db_sg_id]
  backup_retention    = var.backup_retention_days
  skip_final_snapshot = var.environment != "production"
}

# ==========================================
# Modules: Monitoring
# ==========================================

module "monitoring" {
  source = "./modules/monitoring"

  environment    = var.environment
  instance_ids   = module.compute.instance_ids
  db_instance_id = module.database.db_instance_id
}
