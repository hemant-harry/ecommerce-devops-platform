output "Repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.app.repository_url
}
output "Repository_ARN" {
  description = "ECR Repository ARN"
  value       = aws_ecr_repository.app.arn
}
