# security.tf
# Security Groups for network access control

# ============================================
# SECURITY GROUP: ALB (Application Load Balancer)
# ============================================

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg-${var.environment}"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id
  
  # Allow HTTPS from anywhere
  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTP from anywhere (will redirect to HTTPS)
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-alb-sg-${var.environment}"
  }
}

# ============================================
# SECURITY GROUP: APPLICATION SERVERS
# ============================================

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg-${var.environment}"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.main.id
  
  # Only allow traffic from ALB on application port
  ingress {
    description     = "Application port from ALB only"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  
  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-app-sg-${var.environment}"
  }
}

# ============================================
# SECURITY GROUP: DATABASE
# ============================================

resource "aws_security_group" "database" {
  name        = "${var.project_name}-database-sg-${var.environment}"
  description = "Security group for database servers"
  vpc_id      = aws_vpc.main.id
  
  # Only allow PostgreSQL from application servers
  ingress {
    description     = "PostgreSQL from application servers only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }
  
  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-database-sg-${var.environment}"
  }
}

# ============================================
# SECURITY GROUP: BASTION HOST (Optional)
# ============================================

resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg-${var.environment}"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id
  
  # SSH from specific IP only (CHANGE THIS!)
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # REPLACE with ["YOUR_IP/32"]
  }
  
  # Allow SSH to private instances
  egress {
    description = "SSH to private instances"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  
  tags = {
    Name = "${var.project_name}-bastion-sg-${var.environment}"
  }
}