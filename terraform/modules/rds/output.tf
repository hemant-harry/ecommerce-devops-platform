output "endpoint" {
	description = "RDS Database endpoint" 
	value = aws_db_instance.main.address
}

output "port" {
	description = "RDS Mysql port"
	value = aws_db_instance.main.port
}
	
output "db_name" {
	description = "DateBase Name" 
	value = aws_db_instance.main.db_name
}



