data "aws_secretsmanager_secret" "read-db-secrets" {
  name = "SECRET_MANAGER_SECRET_NAME"
}
data "aws_secretsmanager_secret_version" "read-db-secrets-username" {
  secret_id     = data.aws_secretsmanager_secret.read-db-secrets.id
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "${var.ENV_NAME}-db-subnet-group"
  subnet_ids = [[for s in var.PRIVATE_SUBNETS : s.id][0],[for s in var.PRIVATE_SUBNETS : s.id][1]]

  tags = {
    Name = "${var.ENV_NAME}-db-subnet-group"
    Terraform = "true"
    Environment = var.ENV_NAME
  }
}

resource "aws_rds_cluster" "aurora_serverless" {
  cluster_identifier = "${var.ENV_NAME}-aurora-cluster-2"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.04.4"

  master_username = jsondecode(data.aws_secretsmanager_secret_version.read-db-secrets-username.secret_string)["username"]
  master_password = jsondecode(data.aws_secretsmanager_secret_version.read-db-secrets-username.secret_string)["password"]

  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [var.INTERNAL_SG]
  skip_final_snapshot    = var.SKIP_FINAL_SNAPSHOT
  final_snapshot_identifier = "${var.ENV_NAME}-aurora-final-snapshot"
  
  serverlessv2_scaling_configuration {
    max_capacity = 2
    min_capacity = 0.5
  }

  tags = {
    Name        = "${var.ENV_NAME}-aurora-cluster-2"
    Terraform   = "true"
    Environment = var.ENV_NAME
  }
}

resource "aws_rds_cluster_instance" "aurora_serverless_instance" {
  identifier         = "${var.ENV_NAME}-aurora-instance-2"
  cluster_identifier = aws_rds_cluster.aurora_serverless.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_serverless.engine
  engine_version     = aws_rds_cluster.aurora_serverless.engine_version

  tags = {
    Name        = "${var.ENV_NAME}-aurora-instance-2"
    Terraform   = "true"
    Environment = var.ENV_NAME
  }
}
