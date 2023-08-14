variable "key" {
  description = "SSH key name for EC2 instance"
  type        = string
  default     = "username@name of the virtual machine"
}

variable "cidr_blocks" {
  description = "CIDR blocks for security group rules"
  type        = list(any)
  default     = [
    "List of white-listed IP address, including GitHub, Terraform registry, and home/office IP CIDR's"
  ]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "env" {
  description = "Environment (dev, stg, prd)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prd"], var.env)
    error_message = "The env variable must be one of: dev, stg, prd."
  }
}

variable "Name" {
  description = "Name to tag resources with"
  type        = string
}