resource "random_password" "db_password" {
  length = 16
}

resource "aws_db_instance" "udagram" {
  identifier             = var.db_identifier
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12.5"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = "udagram"
  password               = random_password.db_password
  parameter_group_name   = "default.postgres12"
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.udagram_postgres.id]
  db_subnet_group_name   = aws_db_subnet_group.udagram.name
}

resource "aws_db_subnet_group" "udagram" {
  name       = "udagram-postgres-subnet"
  subnet_ids = aws_subnet.udagram_public[*].id

  tags = {
    Name = "Udagram Postgres subnet"
  }
}
