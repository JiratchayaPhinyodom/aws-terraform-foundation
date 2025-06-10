module "environment-dev" {
  source = "./modules/environment"

  ENV_NAME = ""
  EKS_CLUSTER_VERSION = "1.32"
  DESIRED_SIZE = 3
  MAX_SIZE = 5
  MIN_SIZE = 3
  PRIVATE_SUBNETS_ID = data.aws_subnets.private.ids
  PUBLIC_SUBNETS_ID = data.aws_subnets.public.ids
  INSTANCE_NODE_TYPE = "t3.medium"

}

module "database-my-env-dev" {
  source = "./modules/database-env"
  RDS_INSTANCE_TYPE = "Serverless v2"
  ENV_NAME = ""
  PRIVATE_SUBNETS = data.aws_subnet.private_subnet
  VPC_ID = data.aws_vpc.selected.id
  INTERNAL_SG = aws_security_group.internal-sg.id
  ROUTE53_ZONE_ID = ""
  SKIP_FINAL_SNAPSHOT = false
}