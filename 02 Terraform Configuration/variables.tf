variable "aws_amis" {
  description = "The AMI to use for setting up the instances."
  default = {
    # Ubuntu Xenial 16.04 LTS
    "eu-west-1" = "ami-58b7972b"
    "eu-west-2" = "ami-ede2e889"
    "eu-central-1" = "ami-1535f57a"
    "us-east-1" = "ami-bcd7c3ab"
    "us-east-2" = "ami-fcc19b99"
    "us-west-1" = "ami-ed50018d"
    "us-west-2" = "ami-15d76075"
  }
}

data "aws_availability_zones" "available" {}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-2"
}

variable "instance_user" {
  description = "The user account to use on the instances to run the scripts."
  default     = "ubuntu"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default     = "capstone"
}

variable "master_instance_type" {
  description = "The instance type to use for the Kubernetes master."
  default     = "t2.micro"
}

variable "node_instance_type" {
  description = "The instance type to use for the Kubernetes nodes."
  default     = "t2.micro"
}

variable "node_count" {
  description = "The number of nodes in the cluster."
  default     = "3"
}

variable "private_key_path" {
  description = "The private key for connection to the instances as the user. Corresponds to the key_name variable."
  default     = "~/.ssh/capstone.pem"
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
}
