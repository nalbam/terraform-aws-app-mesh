module "dynamic_subnets" {
  source                  = "git::https://github.com/bitflight-public/terraform-aws-dynamic-subnets.git?ref=feature/set_subnet_counts"
  context                 = "${module.label.context}"
  region                  = "${data.aws_region.current.name}"
  availability_zones      = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b"]                                   // Optional list of AZ's to restrict it to
  vpc_id                  = "${module.vpc.vpc_id}"
  igw_id                  = "${module.vpc.igw_id}"
  public_subnet_count     = "2"                                                                                                        // Two public zones for the load balancers
  private_subnet_count    = "3"                                                                                                        // Four private zones for the 
  map_public_ip_on_launch = "true"

  ## You can use nat_gateway_enabled or nat_instance_enabled
  ## It creates one nat instance per public subnet.
  ## So if you want to exclude the public subnet by setting the public_subnet_count to 0
  ## You will neet to use the nat_gateway_enabled option.
  nat_instance_enabled = "false"

  nat_gateway_enabled = "true"

  providers {
    "aws" = "aws"
  }
}

## VPC module doesn't have the latest version of null_label 
## module integrated with it at the time of this example being 
## written so no context variable here.
module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.4.1"
  namespace  = "${module.label.namespace}"
  stage      = "${module.label.environment}"
  name       = "${module.label.name}"
  attributes = ["${module.label.attributes}"]
  delimiter  = "${module.label.delimiter}"
  tags       = "${module.label.tags}"
  cidr_block = "${var.vpc_cidr}"
}

data "aws_region" "current" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
