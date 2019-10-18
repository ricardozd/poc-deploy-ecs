module "core" {
  source = "./modules/core"
}

module "helloworld" {
  source = "./modules/base/helloworld"
  name   = "helloworld"
  cluster_ecr_id = module.core.cluster_ecr_id
  log = module.core.log_name
  sns = module.core.sns_arn
}

module "ping" {
  source = "./modules/base/ping"
  name   = "ping"
  cluster_ecr_id = module.core.cluster_ecr_id
  log = module.core.log_name
  sns = module.core.sns_arn
}