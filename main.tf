terraform {
    required_version = ">= 0.12"
    backend "s3" {
        bucket = "mikelu-bucket"
        key    = "terraform/terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = var.region
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name           = "${var.name_prefix}-vpc"
    cidr           = var.vpc_cidr
    azs            = [var.availability_zone]
    public_subnets = [var.subnet_cidr]

    vpc_tags = {
        Name = "${var.name_prefix}-vpc"
    }
    public_subnet_tags = {
        Name = "${var.name_prefix}-subnet"
    }
    igw_tags = {
        Name = "${var.name_prefix}-igw"
    }
    public_route_table_tags = {
        Name = "${var.name_prefix}-rt"
    }
    tags = {
        Terraform = "true"
    }
}

module "ec2" {
    source          = "./modules/ec2"
    vpc_id          = module.vpc.vpc_id
    subnet_id       = module.vpc.public_subnets[0]
    name_prefix     = var.name_prefix
    my_ip           = var.my_ip
    public_key_path = var.public_key_path
}
