# # Create an EC2 Instance
# resource "aws_instance" "data-migration-ec2" {
#   ami                    = var.ami_id # Replace with your desired AMI
#   instance_type          = var.ec2_instance_type
#   subnet_id              = aws_subnet.my_private_app_subnet_az1.id
#   iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
#   vpc_security_group_ids = [aws_security_group.data-migration-server-sg.id]

#   tags = {
#     Name = "${var.environment}-Data-migration-EC2"
#   }
# }
