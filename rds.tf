
resource "aws_db_subnet_group" "my-db-subnets" {
  name        = "db-subnets"
  subnet_ids  = [aws_subnet.my_private_data_subnet_az1.id, aws_subnet.my_private_data_subnet_az2.id]
  description = "db-subnets"


  tags = {
    Name = "${var.environment}-db-subnets"
  }
}

# create rds database
resource "aws_db_instance" "dev-rds-db" {
  engine                  = var.engine_type
  engine_version          = var.engine_version
  multi_az                = var.multi_az_deployment
  identifier              = var.db_identifier
  username                = var.db-username
  password                = var.db-password
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds-sg.id]
  db_subnet_group_name    = aws_db_subnet_group.my-db-subnets.name
  db_name                 = var.database_name
  backup_retention_period = 7
  skip_final_snapshot     = true

}













