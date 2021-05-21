module "ec2_sg" {
    source = "terraform-aws-modules/security-group/aws"

    name        = "${var.name_prefix}-ec2-sg"
    description = "Security Group for EC2 instance"
    vpc_id      = var.vpc_id

    ingress_cidr_blocks = ["${var.my_ip}/32"]
    ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]

    egress_rules = ["all-all"]

    tags = {
        Name = "${var.name_prefix}-ec2-sg"
        Terraform = "true"
    }
}

data "aws_ami" "latest_ami" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_key_pair" "ssh_key" {
    key_name = "${var.name_prefix}-ssh-key"
    public_key = file(var.public_key_path)

    tags = {
        Terraform = "true"
    }
}

module "ec2_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name           = "${var.name_prefix}-ec2" 
    instance_count = 1

    ami                    = data.aws_ami.latest_ami.id
    instance_type          = "t2.micro"
    key_name               = aws_key_pair.ssh_key.key_name
    vpc_security_group_ids = [module.ec2_sg.security_group_id]
    subnet_id              = var.subnet_id

    tags = {
        Terraform = "true"
    }
}
