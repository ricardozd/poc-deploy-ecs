variable "cluster_name" {
  default = "ecs-cluster"
}

variable "subnets" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}