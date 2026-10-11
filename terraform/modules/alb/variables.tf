variable "project_name" {
	type = string 
	description = "Name of project"
	}

variable "environment" {
	type = string 
	description = "Deployment Environment"
}

variable "vpc_id" {
	type = string 
	description = "VPC id where you want to create ALB"
	}
variable "public_subnet_ids" {
	type = list(string)
	description = "Public subet ids where you want to create ALB"
}

variable "alb_security_group_id" {
	type = string 
	description = "SG ids which attach to ALB"
}
