// This is a provider block. It sets Terraform up to be able to do things with AWS.
provider "aws" {
  region = var.aws_region
}

// This data block allows us to grab the most recent AWS Linux 2 AMI for the current region.
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

// This resource block creates an EC2 instance with the AMI.
resource "aws_instance" "backend" {
  instance_type = "t2.micro"
  ami = data.aws_ami.amazon-linux-2.id
  root_block_device {
    volume_size = var.disk_size
  }
}
