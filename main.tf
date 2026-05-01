# main.tf
# Core VPC infrastructure

# ============================================
# VPC (Virtual Private Cloud)
# ============================================
# Your isolated network in AWS

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  # Enable DNS for services like RDS that need hostnames
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.project_name}-vpc-${var.environment}"
  }
}

# ============================================
# INTERNET GATEWAY
# ============================================
# Allows public subnets to access the internet

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-igw-${var.environment}"
  }
}

# ============================================
# PUBLIC SUBNETS
# ============================================
# Subnets with direct internet access

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true  # Auto-assign public IPs to instances
  
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}-${var.environment}"
    Type = "Public"
    AZ   = var.availability_zones[count.index]
  }
}

# ============================================
# PRIVATE SUBNETS
# ============================================
# No direct internet, but can reach out via NAT Gateway

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false  # No public IPs
  
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}-${var.environment}"
    Type = "Private"
    AZ   = var.availability_zones[count.index]
  }
}

# ============================================
# DATABASE SUBNETS
# ============================================
# Most secure - completely isolated from internet

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.project_name}-database-subnet-${count.index + 1}-${var.environment}"
    Type = "Database"
    AZ   = var.availability_zones[count.index]
  }
}

# ============================================
# ELASTIC IPs FOR NAT GATEWAYS
# ============================================
# Static public IPs for NAT Gateways

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0
  domain = "vpc"
  
  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}-${var.environment}"
  }
  
  # EIP must be created after Internet Gateway
  depends_on = [aws_internet_gateway.main]
}

# ============================================
# NAT GATEWAYS
# ============================================
# Allow private subnets to access internet
# (outbound only - no inbound connections)

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = {
    Name = "${var.project_name}-nat-gateway-${count.index + 1}-${var.environment}"
    AZ   = var.availability_zones[count.index]
  }
  
  depends_on = [aws_internet_gateway.main]
}