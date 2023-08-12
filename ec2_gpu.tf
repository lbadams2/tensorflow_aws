data "aws_ami" "dlami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["AWS Deep Learning AMI GPU CUDA 11.4.3 (Ubuntu 20.04)*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["898082745236"] # Amazon account
}

resource "aws_instance" "gpu" {
  ami           = data.aws_ami.dlami.id
  instance_type = "g4dn.xlarge" # 4 NVIDIA T4 GPUs, 7.5 compute capability
  subnet_id            = module.vpc.private_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.ec2.id
  user_data            = data.template_file.user_data.rendered
  vpc_security_group_ids = [aws_security_group.ec2.id]

  root_block_device {
    volume_size = 40
  }
}