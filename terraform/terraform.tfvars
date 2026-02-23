ami_id        = "ami-0fd44c32f6265fe1a"
instance_type = "t2.micro"
key_name      = "mumbai_key"
ssh_cidr      = ["0.0.0.0/0"]

common_tags = {
  Project     = "terraform-assignment"
  Environment = "dev"
  Owner       = "sakshi"
}

vpc_cidr      = "10.0.0.0/16"
public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
alb_name      = "mongodb-alb"
asg_name      = "mongodb-asg"
ansible_user  = "ubuntu"
ssh_key_path  = "/tmp/mumbai_key"
alb_port      = 80
vpc_name      = "mongodb-vpc"
igw_name      = "mongodb-igw"
nat_name      = "mongodb-nat"
