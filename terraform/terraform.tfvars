# ✅ Ubuntu 22.04 x86_64 AMI (for ap-south-1 / Mumbai)
ami_id = "ami-053b12d3152c0cc71"

# ✅ Nitro-based instance type (UEFI-compatible + Free Tier eligible)
instance_type = "t3.micro"

# ✅ Your existing AWS key pair name
key_name = "mumbai_key"

# ✅ Allow SSH from anywhere (you can restrict later)
ssh_cidr = ["0.0.0.0/0"]

# ✅ Common tags for all resources
common_tags = {
  Project     = "terraform-assignment"
  Environment = "dev"
  Owner       = "sakshi"
}

# ✅ Networking configuration
vpc_cidr      = "10.0.0.0/16"
public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

# ✅ Load Balancer and Auto Scaling details
alb_name = "mongodb-alb"
asg_name = "mongodb-asg"

# ✅ SSH access settings (Make sure this file exists and has correct permissions)
ansible_user = "ubuntu"
ssh_key_path = "/tmp/mumbai_key"

# ✅ Application settings
alb_port = 80
vpc_name = "mongodb-vpc"
igw_name = "mongodb-igw"
nat_name = "mongodb-nat"
