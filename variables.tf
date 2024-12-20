# vpc variable
variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type        = string
}

# variable for environmet
variable "environment" {
  description = "environment name"
  type        = string
}

# variable for public subnet AZ1
variable "public_subnet_az1_cidr" {
  description = "public subnet az1 cidr block"
  type        = string
}

# variable for public subnet AZ2
variable "public_subnet_az2_cidr" {
  description = "public subnet az2 cidr block"
  type        = string
}

# variable for private app subnet AZ1
variable "private_app_subnet_az1_cidr" {
  description = "private app subnet az1 cidr block"
  type        = string
}

# variable for private app subnet AZ2
variable "private_app_subnet_az2_cidr" {
  description = "private app subnet az2 cidr block"
  type        = string
}

# variable for private data subnet AZ1
variable "private_data_subnet_az1_cidr" {
  description = "private data subnet az1 cidr block"
  type        = string
}

# variable for private data subnet AZ2
variable "private_data_subnet_az2_cidr" {
  description = "private data subnet az2 cidr block"
  type        = string
}

# # security group variables
# variable "ssh_location" {
#   #default     = "0.0.0.0/0" # in real world limited to your ip
#   description = "the ip address that can ssh into the ec2 instance"
#   type        = string
# }

# database variables
variable "db-username" {
  description = "the username of the database"
  type        = string
}

variable "db-password" {
  description = "the password of the database"
  type        = string
}

variable "db_instance_class" {
  #default     = "db.t3.micro"
  type        = string
  description = "database instance type"
}

variable "db_identifier" {
  # default     = "dev-db"
  type        = string
  description = "database identifier"

}

variable "multi_az_deployment" {
  default     = false
  type        = bool
  description = "create a standby db instance"

}

variable "engine_type" {
  #default     = "mysql"
  type        = string
  description = "create a mysql db instance"

}

variable "engine_version" {
  description = "The version of the database engine (e.g., 8.0 for MySQL)"
  type        = string
  #default     = "8.0.39"
}

variable "allocated_storage" {
  description = "The amount of storage (in GB) to allocate for the database"
  type        = number
  #default     = 20
}

variable "storage_type" {
  description = "The type of storage to use (e.g., gp2 for General Purpose SSD)"
  type        = string
  #default     = "gp2"
}

variable "database_name" {
  description = "The name of the database to create"
  type        = string
  #default     = "devdb"
}

# Application load balancer variables
variable "ssl_certificate_arn" {
  description = "The ARN of the SSL certificate to use for the ALB"
  type        = string
  #default     = "arn:aws:acm:us-east-1:473208108378:certificate/fcd879ea-2e8a-4c1c-93cc-e12729e0aa2a"

}

# SNS topic variables
variable "notification_email" {
  description = "The email address to send notifications to"
  type        = string
  #default     = "inyeza.amedimele86@gmail.com"
}

# auto scaling group variables
variable "launch_template_name" {
  description = "name of the launch template"
  type        = string
}

variable "ec2_image_id" {
  description = "the AMI to launch the template"
  type        = string
}

variable "new_instance_type" {
  description = "the instance from the AMI"
  type        = string
}

# # Data migration AMI variable
# variable "ami_id" {
#   description = "The AMI ID to use for the EC2 instance"
#   type        = string
# }

# # Data migration ec2 instance_type
# variable "ec2_instance_type" {
#   description = "The type of EC2 instance to use"
#   type        = string
# }












