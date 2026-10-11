variable "project_name" {
  description = "Project_name"
  type        = string
}
variable "environment" {
  description = "Environment"
  type        = string
}

variable "db_password_secret_arn" {
  description = "ARN of the database password secret"
  type        = string
}
