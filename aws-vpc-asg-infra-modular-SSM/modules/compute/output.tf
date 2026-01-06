output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_alb.Application_LB.dns_name
}