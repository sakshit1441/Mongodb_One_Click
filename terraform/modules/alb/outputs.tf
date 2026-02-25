##########################
# ALB Outputs
##########################

# Target group ARN
output "tg_arn" {
  description = "ARN of the target group attached to the ALB"
  value       = aws_lb_target_group.tg.arn
}

# ALB DNS name
output "alb_dns" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

# Correct Security Group Output
output "alb_sg_id" {
  description = "Security group ID for the ALB"
  value       = local.alb_sg_id
}

# ALB ARN
output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}
