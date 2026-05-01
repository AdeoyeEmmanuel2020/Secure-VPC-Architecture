# routing.tf
# Route tables for traffic management

# ============================================
# PUBLIC ROUTE TABLE
# ============================================
# Routes internet traffic through Internet Gateway

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-public-rt-${var.environment}"
    Type = "Public"
  }
}

# Route all internet traffic (0.0.0.0/0) to Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ============================================
# PRIVATE ROUTE TABLES
# ============================================
# One route table per AZ for high availability

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)
  
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-private-rt-${count.index + 1}-${var.environment}"
    Type = "Private"
    AZ   = var.availability_zones[count.index]
  }
}

# Route internet traffic through NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? length(var.private_subnet_cidrs) : 0
  
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

# Associate private subnets with private route tables
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ============================================
# DATABASE ROUTE TABLES
# ============================================
# No internet routes - completely isolated

resource "aws_route_table" "database" {
  count = length(var.database_subnet_cidrs)
  
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-database-rt-${count.index + 1}-${var.environment}"
    Type = "Database"
    AZ   = var.availability_zones[count.index]
  }
}

# Associate database subnets with database route tables
# Note: No internet route - databases are fully isolated
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}