# variables.tf
# Input variables for VPC configuration

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "secure-vpc"
}

# VPC CIDR block
# Explanation: 10.0.0.0/16 gives you 65,536 IP addresses
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Availability Zones for high availability
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Public subnet CIDR blocks
# Each /24 gives 256 IP addresses
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Private subnet CIDR blocks
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# Database subnet CIDR blocks
variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

# Enable VPC Flow Logs for monitoring
variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs for monitoring"
  type        = bool
  default     = true
}

# Enable NAT Gateway
# Warning: NAT Gateway costs ~$32/month per gateway
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true  # Set to false for cost savings in demo
}