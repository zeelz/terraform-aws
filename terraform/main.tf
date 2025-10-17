terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~>4.19.0"
        }
    }

    # transfer state file to s3
    backend "s3" {} #values passed as -backend-config

    # backend "s3" {
    #   bucket    = "zeelz-terraform-bucket"
    #   key       = "terraform.tfstate"
    #   encrypt   = true
    #   region    = "us-east-1"
    #   profile   = "zeelz"
    # }
}

provider "aws" {
    region  = "us-east-1"
    # profile = "zeelz"
}

# this bucket has been rm'ed from tf so when i destory everything it won't be affected
# it is used for state mgmt - backend

# resource "aws_s3_bucket" "t_bucket" {
#     bucket      = "zeelz-terraform-bucket"
# }

resource "aws_key_pair" "zeelz_db" {
    key_name   = "zeelz_db_ec2"
    public_key = var.ssh_private_key
}

variable "ssh_private_key" {
  type          = string
  description   = "stored in gitlab console"
}

resource "aws_security_group" "devops_test_sg" {
    name      = "devops_test_sg"
    vpc_id    = "vpc-04f9481b7c282ba7b"

    ingress {
        cidr_blocks         = ["0.0.0.0/0"]
        protocol            = "tcp"
        to_port             = 3300
        from_port           = 3300
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

resource "aws_instance" "zeelz_db_ec2" {
    ami                             = "ami-08982f1c5bf93d976"
    instance_type                   = "t2.micro"
    # vpc_security_group_ids          = ["sg-033eebe707ffaa9c2"]
    vpc_security_group_ids          = [aws_security_group.devops_test_sg.id]
    key_name                        = aws_key_pair.zeelz_db.key_name
    associate_public_ip_address     = true
    user_data                       = file("${path.module}/user-data.sh")
}

output "zeelz_db_ec2_ip" {
    value = aws_instance.zeelz_db_ec2.public_ip
}