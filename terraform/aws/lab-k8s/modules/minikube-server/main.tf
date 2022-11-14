resource "aws_default_security_group" "lab-k8s-default-sg" {
    vpc_id = var.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
        Name = "lab-k8s-default-sg"
    }
}

data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = [var.image_name]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "lab-k8s-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_default_security_group.lab-k8s-default-sg.id]
    availability_zone = var.availability_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.lab-k8s-ssh-key.key_name
#    key_name = "tf-server"
    tags = {
        Name = "lab-k8s-server"
    }
    user_data = file("entry-script.sh")
    root_block_device {
        volume_size = 8
        tags =  {
            Name = "lab-k8s-root-volume"
        }
    }
}

resource "aws_key_pair" "lab-k8s-ssh-key" {
    key_name = "server-key"
    public_key = file(var.public_key_location)
}

