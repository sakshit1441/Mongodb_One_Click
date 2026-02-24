########################################
# VPC Configuration
########################################

variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

########################################
# ALB Configuration
########################################

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "mongodb-alb"
}

variable "alb_port" {
  description = "Port on which ALB listens"
  type        = number
  default     = 80
}

variable "app_port" {
  description = "Port on which application is running"
  type        = number
}

########################################
# Security Group Control (FIX FOR COUNT ERROR)
########################################

variable "create_alb_sg" {
  description = "Whether to create a new ALB security group"
  type        = bool
  default     = true
}

variable "existing_alb_sg_id" {
  description = "Existing ALB Security Group ID (if not creating new one)"
  type        = string
  default     = ""
}

########################################
# Common Tags
########################################

variable "common_tags" {
  description = "Common tags applied to all ALB resources"
  type        = map(string)
  default     = {}
}
