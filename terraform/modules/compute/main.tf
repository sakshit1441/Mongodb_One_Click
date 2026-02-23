########################
# Ubuntu 22.04 AMI (x86_64)
########################
data "aws_ami" "ubuntu_22" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu Official)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

########################
# Security Group (Private EC2)
########################
resource "aws_security_group" "compute_sg" {
  name   = "${var.asg_name}-sg"
  vpc_id = var.vpc_id

  # SSH only from Bastion SG
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  # App traffic from ALB
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.asg_name}-sg" })
}

########################
# Launch Template
########################
resource "aws_launch_template" "mongodb" {
  name_prefix   = "${var.asg_name}-lt-"
  image_id      = data.aws_ami.ubuntu_22.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.compute_sg.id]
  user_data              = base64encode(var.user_data)

  tags = merge(var.common_tags, { Name = "${var.asg_name}-lt" })
}

########################
# Auto Scaling Group
########################
resource "aws_autoscaling_group" "mongodb" {
  name                = var.asg_name
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [var.tg_arn]

  launch_template {
    id      = aws_launch_template.mongodb.id
    version = "$Latest"
  }

  ########################
  # Lifecycle Fix — prevents ASG stuck state
  ########################
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [target_group_arns]
  }

  ########################
  # Proper ASG Tag Format
  ########################
  tag {
    key                 = "Name"
    value               = "mongodb-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

########################
# Data source to fetch running ASG instances
########################
data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.mongodb.name]
  }

  instance_state_names = ["running"]
}
