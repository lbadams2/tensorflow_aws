module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tensorflow"
  cidr = "10.225.184.0/24"

  azs             = ["us-east-1a"]
  private_subnets = ["10.225.184.0/25"]
  public_subnets  = ["10.225.184.128/25"]

  enable_nat_gateway = true
  #enable_dns_hostnames = true
}