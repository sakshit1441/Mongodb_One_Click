##########################
# ALB Security Group (Reuses existing if found)
##########################

# Try to fetch an existing SG by name
data "aws_security_group" "existing_alb_sg" {
  filter {
    name   = "group-name"
    values = ["${var.alb_name}-sg"]
  }
  vpc_id = var.vpc_id
}

# Create SG only if it doesn’t exist
resource "aws_security_group" "alb_sg" {
  count  = data.aws_security_group.existing_alb_sg.id != "" ? 0 : 1
  name   = "${var.alb_name}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.alb_port
    to_port     = var.alb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.alb_name}-sg" })

  lifecycle {
    create_before_destroy = true
  }
}

##########################
# Application Load Balancer
##########################
resource "aws_lb" "this" {
  name               = var.alb_name
  load_balancer_type = "application"
  internal           = false
  subnets            = var.public_subnets

  # ✅ Fixed: uses the existing SG if found, else new one
  security_groups = (
    data.aws_security_group.existing_alb_sg.id != "" ?
    [data.aws_security_group.existing_alb_sg.id] :
    [aws_security_group.alb_sg[0].id]
  )

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

##########################
# Target Group
##########################
resource "aws_lb_target_group" "tg" {
  name     = "${var.alb_name}-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.common_tags, { Name = "${var.alb_name}-tg" })
}

##########################
# Listener
##########################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}
