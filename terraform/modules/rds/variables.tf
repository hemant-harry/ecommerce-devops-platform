variable "project_name" {
	description = "name  of project "
	type = string 
}

variable "environment" {
	description = "Deployment Environment"
	type = string 
}

variable "db_name" {
	description = "initial name of Database"
	type = string 
}
variable "db_password" {
	description = "Database master Password"
	type = string 
  sensitive = true
}


variable "db_username" {
	description = "master name of database"
  type = string 
}

variable "private_subnet_ids" {
	description = "private subnet ids where db created"
	type = list(string)
}

variable "security_group_ids" {
	description = "Security group ids to conect with DB"
	type = list(string)
}







