########################
# Bastion Module Variables
########################

# VPC where Bastion will be deployed
variable "vpc_id" {
  description = "VPC ID where Bastion host will be created"
  type        = string
}

# Public subnet for Bastion
variable "public_subnet_id" {
  description = "Public subnet ID to launch Bastion host"
  type        = string
}

# AMI ID (can be overridden but defaults to Ubuntu 22.04 x86_64)
variable "ami_id" {
  description = "AMI ID for Bastion host (default: Ubuntu 22.04 LTS x86_64)"
  type        = string
  default     = ""
}

# Instance type (Free Tier compatible)
variable "instance_type" {
  description = "EC2 instance type for Bastion host"
  type        = string
  default     = "t3.micro"
}

# SSH key pair (must exist in AWS)
variable "key_name" {
  description = "Name of the AWS key pair to associate with Bastion"
  type        = string
}

# CIDR blocks allowed to SSH
variable "ssh_cidr" {
  description = "CIDR blocks allowed SSH access to Bastion"
  type        = list(string)
}

# Common tags for all resources
variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
}

# Private key path for remote file provisioning
variable "ssh_key_path" {
  description = "Path to the private key used for SSH into Bastion (for file copy)"
  type        = string
}
