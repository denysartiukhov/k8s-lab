terraform {
    required_version = ">=0.12"
    backend "s3" {
        bucket = "denysartiukhov-k8s-lab-tf-state"
        key = "state.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "lab-k8s-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        name = "lab-k8s-vpc"
    }
}

module "lab-k8s-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    availability_zone = var.availability_zone
    vpc_id = aws_vpc.lab-k8s-vpc.id
    default_route_table_id = aws_vpc.lab-k8s-vpc.default_route_table_id
}

module "lab-k8s-server" {
    source = "./modules/minikube-server"
    vpc_id = aws_vpc.lab-k8s-vpc.id
    my_ip = var.my_ip
    image_name = var.image_name
    public_key_location = var.public_key_location
    instance_type = var.instance_type
    subnet_id = module.lab-k8s-subnet.subnet.id
    availability_zone = var.availability_zone
}

