variable "region" {
  default = "ap-south-1"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  type = string
}

variable "ssh_cidr" {
  type = list(string)
}


variable "common_tags" {
  type = map(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "alb_name" {
  description = "Name for the ALB"
  type        = string
  default     = "mongodb-alb"
}

variable "asg_name" {
  description = "Name for the ASG"
  type        = string
  default     = "mongodb-asg"
}

variable "user_data" {
  description = "User data script for compute instances"
  type        = string
  default     = ""
}

variable "ansible_user" {
  description = "SSH user for Ansible"
  type        = string
  default     = "ubuntu"
}

variable "ssh_key_path" {
  description = "Path to SSH private key for Ansible"
  type        = string
  default     = "../mumbai_key"
}

variable "alb_port" {
  description = "Port for the Application Load Balancer"
  type        = number
  default     = 80
}


variable "inventory_file" {
  description = "Path to the Ansible inventory file"
  type        = string
  default     = "../ansible/inventory.ini"
}

variable "app_port" {
  description = "Port the application is listening on"
  type        = number
  default     = 27017
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "mongodb-vpc"
}

variable "igw_name" {
  description = "Name for the Internet Gateway"
  type        = string
  default     = "mongodb-igw"
}

variable "nat_name" {
  description = "Name for the NAT Gateway"
  type        = string
  default     = "mongodb-nat"
}
