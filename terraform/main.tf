terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~>4.19.0"
        }
    }

    # transfer state file to s3
    backend "s3" {
        bucket  = "zeelz-terraform-bucket"
        key     = "terraform.tfstate"
        encrypt   = true
        region    = "us-east-1"
    }
}

provider "aws" {
    region  = "us-east-1"
}

resource "aws_key_pair" "zeelz_db" {
    key_name   = "zeelz_db_ec2"
    public_key = var.ZEELZ_MACHINE_SSH_PUBLIC_KEY
}

resource "aws_security_group" "devops_test_sg" {
    name      = "devops_test_sg"
    vpc_id    = var.VPC_ID_DEFAULT #aws_vpc.main.id #

    ingress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "tcp"
        to_port             = 3300
        from_port           = 3300
    }
    ingress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "tcp"
        to_port             = 5500
        from_port           = 5500
    }
    ingress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "tcp"
        to_port             = 22
        from_port           = 22
    }
    egress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "-1" # for all protocols
        to_port             = 0
        from_port           = 0
    }
}

resource "aws_instance" "zeelz_db_ec2" {
    ami                             = "ami-08982f1c5bf93d976"
    instance_type                   = "t2.micro"
    # vpc_security_group_ids          = ["sg-033eebe707ffaa9c2"]
    vpc_security_group_ids          = [aws_security_group.devops_test_sg.id]
    key_name                        = aws_key_pair.zeelz_db.key_name
    associate_public_ip_address     = true
    user_data                       = file("${path.module}/user-data.sh")
}

variable "ZEELZ_MACHINE_SSH_PUBLIC_KEY" {
    type                     = string # supplied from env var with TF_VAR_ prefix
}

variable "VPC_ID_DEFAULT" {
    type                     = string
}

output "zeelz_db_ec2_ip" {
    value                  = aws_instance.zeelz_db_ec2.public_ip
}