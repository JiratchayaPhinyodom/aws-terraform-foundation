# Use existing VPC
data "aws_vpc" "selected" {
  id = ""
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*Private*"]
  }
}

data "aws_subnet" "private_subnet" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*Public*"]
  }
}

data "aws_subnet" "public_subnet" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}