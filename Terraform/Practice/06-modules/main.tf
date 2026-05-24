module "ec2_creation" {
  source        = "./modules/EC2-creation"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  instance_name = var.instance_name
  key_pair      = var.key_pair
}
