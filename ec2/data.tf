data "aws_caller_identity" "current" {}


data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "devops-practice-with-ansible"
  owners      = [data.aws_caller_identity.current.account_id]
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_route53_zone" "zone" {
  name         = "shujathdevops.online"
}
