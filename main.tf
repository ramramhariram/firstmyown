terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.66.0"
    }
  }
}

resource "aws_elb_attachment" "elb_underlay" {
	for_each = var.services
  elb      = var.elbname
  instance = each.value.node
}

provider "aws" {
  region = var.region
}
