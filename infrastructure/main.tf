module "core" {
  source       = "./modules/core"
  cluster_name = var.cluster_name
}

module "helloworld" {
  source         = "./modules/base/helloworld"
  name           = "helloworld"
  cluster_ecr_id = module.core.cluster_ecs_id
  log            = module.core.log_name
  sns            = module.core.sns_arn
  vpc_id         = var.vpc_id
  subnets        = var.subnets
}

module "ping" {
  source         = "./modules/base/ping"
  name           = "ping"
  cluster_ecr_id = module.core.cluster_ecs_id
  log            = module.core.log_name
  sns            = module.core.sns_arn
  vpc_id         = var.vpc_id
  subnets        = var.subnets
}