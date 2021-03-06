# variable settings
# this terraform is set up a dev docker-data-center in aws

variable "env" {
  description = "code for the env: dev or prod"
}

variable "aws_region" {
  description = "aws region"
  default = "us-east-1"
}

variable "aws_ami" {
  description = "aws golden image ami"
  default = "ami-8c1be5f6"
}

variable "instance_type" {
  description = "aws instance type"
  type = "map"
  default = {
    "dev" = "t2.micro"
    "prod"  = "m3.medium"
  }
}

variable "subnet" {
  description = "aws subnet id"
  type = "map"
  default = {
    "dev" = "subnet-cae60f97"
    "prod"  = "subnet-ad4ac3c9"
  }
}

# configure backend state using S3 for team sharing on build state
data "terraform_remote_state" "aws_infra" {
  backend = "s3"
  config {
    bucket = "aws-infra-tf-state"
    key = "infra/${var.env}/terraform.tfstate"
    region = "${var.aws_region}"
  }
}

# configure aws provider
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "docker_swarm" {
  count = "3"
  ami = "${var.aws_ami}"
  instance_type = "${lookup(var.instance_type,var.env)}"
  subnet_id = "${lookup(var.subnet, var.env)}"

  tags {
    Name = "docker_swarm"
  }
}

resource "aws_security_group" "instance" {
  name = "docker_swarm_instance"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
