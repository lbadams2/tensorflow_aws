data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
}

# https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-ssm-agent.html
resource "aws_instance" "foo" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.xlarge"
  subnet_id            = module.vpc.private_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.ec2.id
  user_data            = data.template_file.user_data.rendered
  vpc_security_group_ids = [aws_security_group.ec2.id]

  root_block_device {
    volume_size = 40
  }
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role" "ec2" {
  name = "ec2-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    ManagedByTFE = "true"
  }

}

resource "aws_iam_role_policy_attachment" "ssm-attach" {
  role       = aws_iam_role.ec2.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}


resource "aws_security_group" "ec2" {
  name    = "ec2-sg"
  vpc_id = module.vpc.vpc_id
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_blocks     = ["::/0"]
  }
}