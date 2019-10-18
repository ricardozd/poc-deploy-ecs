variable "name" {}

variable "log" {}

variable "cluster_ecr_id" {}

variable "sns" {}

variable "health_check_healthy_threshold" {
  description = "The number of checks before the instance is declared healthy"
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "The number of checks before the instance is declared unhealthy"
  default     = 3
}

variable "health_check_timeout" {
  description = "The length of time before the check times out"
  default     = 4
}

variable "health_check_interval" {
  description = "The interval between checks"
  default     = 10
}

variable "subnets" {
  type    = "string"
  default = "subnet-ae3970c8,subnet-8ed28bc6,subnet-8771fadd"

}

variable "vpc_id" {
  type    = "string"
  default = "vpc-a6d1cdc0"
}