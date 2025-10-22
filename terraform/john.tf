terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.19.0"
    }
  }

  backend "s3" {
    bucket  = "..."
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}


provider "aws" {
  region  = var.region
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "default_vpc" {
  type = string
  default = "vpc-04f9481b7c282ba7b"
}

variable "subnet_a" {
  type = string
  default = "..."
}

variable "subnet_b" {
  type = string
  default = "..."
}

variable "ssh_private_key" {
  type          = string
  default       = "..."
}

variable "ec2_ami" {
  type          = string
  default       = "ami-08982f1c5bf93d976"
}


# CREATE SUBNET GROUP
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [var.subnet_a, var.subnet_b]
}

# CREATE SECURITY GROUP

resource "aws_security_group" "ec2_sg" {
    name      = "ec2-sg"
    vpc_id    = var.default_vpc

    ingress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "tcp"
        to_port             = 5432
        from_port           = 5432
    }
    ingress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "tcp"
        to_port             = 22
        from_port           = 22
    }
    ingress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "tcp"
        to_port             = 5500
        from_port           = 5500
    }
    egress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "-1" #all protocols
        to_port             = 0
        from_port           = 0
    }
}

resource "aws_db_instance" "primary" {
    identifier              = "zeelz-postgres-db"
    engine                  = "postgres"
    engine_version          = "16.6"
    instance_class          = "db.t3.micro"
    allocated_storage       = 20
    storage_type            = "gp2"
    db_name                 = "zeelz_postgres_db"
    username                = "zeelz_user"
    password                = "SecurePassword1!"
    db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids  = [aws_security_group.rds_sg.id]
    multi_az                = false
    publicly_accessible     = true
    skip_final_snapshot     = true
}

resource "aws_key_pair" "john_ec2_key" {
    key_name   = "john-ec2-key"
    public_key = var.ssh_private_key
}

resource "aws_instance" "john_ec2" {
    ami                             = var.ec2_ami
    instance_type                   = "t2.micro"
    vpc_security_group_ids          = [aws_security_group.ec2_sg.id]
    key_name                        = aws_key_pair.john_ec2_key.key_name
    associate_public_ip_address     = true
}

output "john_ec2_ip" {
    value = aws_instance.john_ec2.public_ip
}