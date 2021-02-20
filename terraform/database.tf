resource "random_password" "db_password" {
  length = 16
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.db_identifier

  engine            = "postgres"
  engine_version    = "12.5"
  instance_class    = "db.t2.micro"
  allocated_storage = 5

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = var.db_username
  name     = var.db_name
  password = random_password.db_password.result
  port     = "5432"

  vpc_security_group_ids = [aws_security_group.udagram_postgres.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  # DB subnet group
  subnet_ids          = module.vpc.database_subnets
  publicly_accessible = true

  # DB parameter group
  family = "postgres12"

  # DB option group
  major_engine_version = "12"
}
