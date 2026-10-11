# ALB Security-Group 

resource "aws_security_group" "alb" {
	name 		       	= "${var.project_name}-${var.environment}-alb"
	description		 = "allow web-traffic to ALB"
	vpc_id			 = var.vpc_id

	tags = {
		Name = "${var.project_name}-${var.environment}-alb-sg"
	}
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
	security_group_id 	= aws_security_group.alb.id
	description 		= "HTTP form internet"
	ip_protocol 		= "tcp"
	from_port 		= 80
	to_port 		= 80 
	cidr_ipv4 		= "0.0.0.0/0"

	}

resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
	security_group_id	 = aws_security_group.alb.id 
	description 		= "Application Traffic"
	ip_protocol 		= "tcp"
	from_port		= 3000
	to_port 		= 3000
	cidr_ipv4		= "10.0.0.0/16"
}

# ECS Security Group 

resource "aws_security_group" "ecs" {
	name			 = "${var.project_name}-${var.environment}-ecs"
	description		 = "Allow application traffic form ALB"
	vpc_id			 = var.vpc_id 
	
	tags = {
		Name = "${var.project_name}-${var.environment}-sg-ecs"
	}

}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
	security_group_id		 = aws_security_group.ecs.id
	description			 = "App traffic form ALB"
	ip_protocol			 = "tcp"
	from_port			 = 3000
	to_port				 = 3000
   	referenced_security_group_id	 = aws_security_group.alb.id

}


resource "aws_vpc_security_group_egress_rule" "ecs_to_rds" {
	security_group_id = aws_security_group.ecs.id
	description = "MYSQL Traffic"
	ip_protocol = "tcp"
	from_port = 3306
	to_port = 3306
	cidr_ipv4 = "10.0.0.0/16"

}

resource "aws_vpc_security_group_egress_rule" "ecs_https" {
	security_group_id = aws_security_group.ecs.id
	description = "Allow traffic to outside "
	ip_protocol = "tcp"
	from_port = 443
	to_port = 443
	cidr_ipv4 = "0.0.0.0/0"

}


# RDS Security Group 

resource "aws_security_group" "rds" {
	name = "${var.project_name}-${var.environment}-rds"
	description = "Allow MYSQL only form ECS"
	vpc_id = var.vpc_id

  	tags = {
		Name = "${var.project_name}-${var.environment}-rds-sg"
}

}



resource "aws_vpc_security_group_ingress_rule" "rds_from_ecs" {
	security_group_id = aws_security_group.rds.id
	description = "MYSQL form ec2 task"
	ip_protocol = "tcp"
	from_port = 3306
	to_port = 3306
	referenced_security_group_id = aws_security_group.ecs.id
}








