variable "AWS_REGION" {
  default = ""
}

variable "PRIVATE_SUBNETS" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default = ["", "", ""]
}

variable "AVAILABILITY_ZONES" {
  description = "A list of Availability Zones"
  type = list(string)
  default = ["", "", ""]
}