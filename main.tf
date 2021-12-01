terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.66.0"
    }
  }
}

resource "aws_elb_attachment" "elb_underlay" {
  for_each = local.cts_services
  elb      = var.elbname
  instance = each.value.node
}

provider "aws" {
  region = var.region
}


locals {
  cts_services = { for k,v in var.services : k => v if v["status"] == "passing" }
}
