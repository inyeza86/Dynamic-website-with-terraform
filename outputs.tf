output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.dev-rds-db.endpoint
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.my_public_subnet2.id
}

output "website_url" {
  value = join("", ["https://", var.record_name, ".", var.domain_name])
}
