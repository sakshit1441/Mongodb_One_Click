##########################
# ALB Security Group
##########################

resource "aws_security_group" "alb_sg" {
  count  = var.create_alb_sg ? 1 : 0
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
# Local value to decide SG ID
##########################

locals {
  alb_sg_id = var.create_alb_sg ? aws_security_group.alb_sg[0].id : var.existing_alb_sg_id
}

##########################
# Application Load Balancer
##########################

resource "aws_lb" "this" {
  name               = var.alb_name
  load_balancer_type = "application"
  internal           = false
  subnets            = var.public_subnets
  security_groups    = [local.alb_sg_id]

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
