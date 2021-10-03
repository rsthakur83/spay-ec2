variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}


variable "az_zone_1" {
  description = "Availability Zone"
  default     = "us-east-1a"
}

variable "az_zone_2" {
  description = "Availability Zone"
  default     = "us-east-1b"
}

variable "instance-type" {
  description = "Instance Type"
  default     = "t2.micro"
}

variable "image_id" {
  description = "Image id"
  default     = "ami-042e8287309f5df03" // us-east-1
//  default     = "ami-08962a4068733a2b6" // us-east-2
}


variable "aws_network_cidr" {
  description = "Network CIDR"
  default     = "10.0.0.0/16"
}


variable "aws_app_subnet_1_cidr" {
  description = "App Private CIDR"
  default     = "10.0.3.0/24"
}

variable "aws_app_subnet_2_cidr" {
  description = "App Private CIDR"
  default     = "10.0.4.0/24"
}


variable "aws_pub_subnet_1_cidr" {
  description = "Public CIDR"
  default     = "10.0.5.0/24"
}

variable "aws_pub_subnet_2_cidr" {
  description = "Public CIDR"
  default     = "10.0.6.0/24"
}

