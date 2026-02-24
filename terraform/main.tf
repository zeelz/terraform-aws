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

variable "VPC_ID_DEFAULT" {
    type    = string # automatically supplied from env var with TF_VAR_ prefix
}

variable "SSH_PUBLIC_KEY" {
  type          = string
  description   = "stored in gitlab console"
}

variable "AWS_AMI" {
  type          = string
  description   = "value in gitlab env vars"
}

variable "INSTANCE_TYPE" {
  type          = string
  default       = "t3.medium"
  description   = "upgraded from t2.micro 1vpcu/1gb mb => t3.small 2vcpu/2gb => 2vcpu/4gb"
}

variable "os_type" {
  type          = string
  default       = "ubuntu" # amazon | ubuntu
  description   = "this variable defines the user-data file to load"
}

# this bucket resource was commented to rm it from tf mgmt so when everything is destoryed it won't be affected
# it is used for state mgmt - backend

# resource "aws_s3_bucket" "t_bucket" {
#     bucket      = "zeelz-terraform-bucket"
# }

resource "aws_key_pair" "zeelz_db" {
    key_name   = "zeelz_db_ec2"
    public_key = var.SSH_PUBLIC_KEY
}

resource "aws_security_group" "devops_test_sg" {
    name      = "devops_test_sg"
    vpc_id    = var.VPC_ID_DEFAULT

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
    ami                             = "${var.AWS_AMI}"
    instance_type                   = "${var.INSTANCE_TYPE}"
    vpc_security_group_ids          = [aws_security_group.devops_test_sg.id]
    key_name                        = aws_key_pair.zeelz_db.key_name
    associate_public_ip_address     = true
    # ansible is now handling configuration, thanks user-data
    user_data                       = file("${path.module}/user-data-${var.os_type}.sh")
    user_data_replace_on_change     = true
    root_block_device {
      volume_size                   = 16
      volume_type                   = "gp3"
    }
}

output "zeelz_db_ec2_ip" {
    value   = aws_instance.zeelz_db_ec2.public_ip
}

output "devops_test_sg_id" {
    value   = aws_security_group.devops_test_sg.id
}