# create security group for the application load balancer
# terraform aws create security group

resource "aws_security_group" "alb-sg" {
  name        = "ALB-SG"
  description = "ALB security group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP ACCESS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS ACCESS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-ALB-SG"
  }
}

# # create security group for the bastion host aka jump box
# # terraform aws create security group
# resource "aws_security_group" "ssh_security_group" {
#   name        = "ssh scecurity group"
#   description = "enable ssh access on port 22"
#   vpc_id      = aws_vpc.my_vpc.id

#   ingress {
#     description = "ssh access"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.ssh_location]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.environment}-SSH-SG"
#   }
# }

# Ec2 Instance connect endpoint SG
resource "aws_security_group" "ec2-instance-connect-endpoint-sg" {
  description = "Ec2 instance connect endpoint security group"
  vpc_id      = aws_vpc.my_vpc.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  tags = {
    Name = "${var.environment}-EICE-SG"
  }
}

# Data migration server security group
resource "aws_security_group" "data-migration-server-sg" {
  description = "Data migration server security group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-instance-connect-endpoint-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name = "${var.environment}-Data-migration-server-SG"
  }

}

# webserver security group

resource "aws_security_group" "web-server-sg" {
  description = "Web server security group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-instance-connect-endpoint-sg.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-WEB-SG"
  }
}

# RDS security group
resource "aws_security_group" "rds-sg" {
  description = "RDS security group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web-server-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.data-migration-server-sg.id]
  }
  tags = {
    Name = "${var.environment}-RDS-SG"
  }
}
