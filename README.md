## Consul Terraform Sync Module for updating AWS ELB

This Terraform module creates an AWS ELB attachment for each instance that gets registered with Consul into an an existing ELB 

## Feature

<!-- replace template instructions below with your content -->



The module is used for Terraform to keep track of new instances that gets registered with Consul and if its an instance that carries a service that needs to be load balanced via an AWS ELB, it then triggers the TF module ELB attachment so that new or recovered instance gets added into to the ELB pool for Load balancing. 

## Requirements

Consul Enterprise, CTS Enterprise and Terraform Cloud Enterprise (TFE or TFCB)

### Ecosystem Requirements



| Ecosystem | Version |
|-----------|---------|
| network infrastructure | >= X.Y.Z |
| [consul](https://www.consul.io/downloads) | >= 1.7 |
| [consul-terraform-sync](https://www.consul.io/docs/nia) | >= 0.1.0 |
| [terraform](https://www.terraform.io) | >= 0.13 |

### Terraform Providers

| Name | Version |
|------|---------|
| myprovider | >= 1.1.0 |

## Setup


1 - Create an AWS Elastic load balancer (ELB) and get its "name"
2 - Add the new (or recovered) instance as an attachment to the ELB

## Usage



| CTS Input variable | Required | Description |
|-------------------|----------|-------------|
| elb_name | true | The name of an existing ELB |

**User Config for Consul Terraform Sync**
#general
log_level = "INFO"
port = 8558
syslog {}
license_path = "$$Local-directory-exact"
buffer_period {
  enabled = true
  min = "5s"
  max = "20s"
}

#Consul connection
consul {
  address = "Consul UI:port"
  token = "CTS TOKEN"
  tls {
  enabled = true
  verify = true
  ca_cert = ""$$Local-directory-exact"/consul-agent-ca.pem"
  cert = ""$$Local-directory-exact"/$$client-agent-ca.pem"
  key = "/home/ubuntu/$$client-agent-ca-key.pem"
  server_name = "localhost"
}
}

task {
 name        = "reinvent-demo-ELB"
 description = "Add instance to ELB"
 source      = "github.com/ramramhariram/underlay"
 services    = "[$$service-name-1,...., $$service-name-n]"
 variable_files = "/home/ubuntu/elb_name.tfvars"
}


#TF CLOUD driver details
driver "terraform-cloud" {
  hostname     = "https://app.terraform.io"
  organization = "$$org-name"
  token        = "$$org-token"
}


```

**Variable file**

Optional input variable file defined by a user for the task above.

elb_name.tfvars
```hcl
"elbname = "terraform-example-elb""
"region = "us-east-1""
```
