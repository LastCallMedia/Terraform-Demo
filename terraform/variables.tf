
variable "aws_region" {
  type = string
  description = "The AWS region to operate in"
  default = "us-east-1"
}

variable "disk_size" {
  type = number
  description = "The size of the disk in GB"
}
