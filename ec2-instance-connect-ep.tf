# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "eice-03ecab3f69e176649"
resource "aws_ec2_instance_connect_endpoint" "eice" {
  preserve_client_ip = false
  security_group_ids = [aws_security_group.ec2-instance-connect-endpoint-sg.id]
  subnet_id          = aws_subnet.my_private_data_subnet_az1.id
  tags = {
    Name = "${var.environment}-EICE"
  }
}
