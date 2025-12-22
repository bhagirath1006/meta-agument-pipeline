# VPC Module - Demonstrates COUNT meta-argument
module "vpc" {
  count = var.vpc_count

  source = "./modules/vpc"

  vpc_count    = 1
  cidr_prefix  = "10"
  environment  = var.environment
  project_name = var.project_name
}

# Security Group Module - Demonstrates FOR_EACH meta-argument
module "security_group" {
  for_each = var.security_groups

  source = "./modules/security_group"

  security_groups = {
    (each.key) = each.value
  }
  vpc_id       = module.vpc[0].vpc_id
  project_name = var.project_name

  depends_on = [module.vpc]
}

# EC2 Module - Demonstrates DEPENDS_ON meta-argument
module "ec2" {
  count = 1

  source = "./modules/ec2"

  instance_count     = var.ec2_instance_count
  instance_type      = "t3.micro"
  subnet_ids         = module.vpc[0].subnet_ids
  security_group_ids = [for key in keys(module.security_group) : module.security_group[key].security_group_ids[key]]
  project_name       = var.project_name
  environment        = var.environment

  depends_on = [
    module.vpc,
    module.security_group
  ]
}

# S3 Module - Demonstrates FOR_EACH and LIFECYCLE meta-arguments
module "s3" {
  for_each = var.s3_buckets

  source = "./modules/s3"

  buckets           = { (each.key) = each.value }
  project_name      = var.project_name
  environment       = var.environment
  enable_encryption = true

  depends_on = [module.ec2]
}
