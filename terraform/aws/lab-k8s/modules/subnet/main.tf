resource "aws_subnet" "lab-k8s-subnet" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.availability_zone
    tags = {
         Name = "lab-k8s-subnet"
    }
}

resource "aws_route_table" "lab-k8s-main-route-table" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lab-k8s-igw.id
    }
    tags = {
        Name = "lab-k8s-main-rtb"
    }
}


resource "aws_internet_gateway" "lab-k8s-igw" {
    vpc_id = var.vpc_id
    tags = {
        Name = "lab-k8s-igw"
    }
}

resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.lab-k8s-subnet.id
    route_table_id = aws_route_table.lab-k8s-main-route-table.id
}
