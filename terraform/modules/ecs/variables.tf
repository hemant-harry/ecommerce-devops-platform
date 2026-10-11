variable "project_name" {
	description = "name of the project"
	type = string 
}

variable "environment" {
	description = "Deployement Environment"
	type = string 
}

variable "private_subnet_ids" {
	description = "Private subnet ids where ECS Run "
	type = list(string)
}

variable "ecs_security_group_id" {
	description = "ECS security group to attach ECS"
	type = string 
}

variable "execution_role_arn" {
	description = "IAM execution role ARN for run ECS task"
	type = string 
}

variable "repository_url" {
	description = "Repository URL for Application image"
	type = string 
}

variable "target_group_arn" {
	description = "ALB target group ARN"
	type = string 
}

variable "db_host" {
  description = "RDS mysql endpoint"
  type = string 
}

variable "db_name" {
  description = "application database name"
  type = string 
}

variable "db_username" {
  description = "Datebase username" 
  type = string 
}
variable "db_password_secret_arn" {
  description = "Secrets Manager ARN containing DB password"
  type = string 
}
variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "v1"
}








