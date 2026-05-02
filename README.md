# Secure VPC Architecture - AWS Terraform Project

A production-grade, secure VPC implementation on AWS using Terraform, demonstrating defence-in-depth network security principles.

-------

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform)](https://www.terraform.io/) 
[![AWS VPC](https://img.shields.io/badge/AWS-VPC-FF9900?logo=amazonaws)](https://aws.amazon.com/vpc/) 
[![Security](https://img.shields.io/badge/Security-Production%20Grade-success)]() 
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE) 
[![Security Groups](https://img.shields.io/badge/Security%20Groups-Defense%20in%20Depth-orange)]() 
[![Flow Logs](https://img.shields.io/badge/Flow%20Logs-Enabled-blueviolet)]() 
[![Multi-AZ](https://img.shields.io/badge/Multi--AZ-High%20Availability-green)]()

----
## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#uick-Start)
- [Project Structure](#project-structure)
- [Detailed Configuration](#Detailed-Configuration)
- [Security Implementation](#security-implementation)
- [Cost Estimation](#cost-estimation)
- [Deployment Guide](#deployment-guide)
- [Verification Steps](#verification-steps)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [Learning Outcomes](#learning-outcomes)
- [Contributing](#contributing)
- [License](#license)
----
## Overview
This project implements a three-tier, highly available VPC architecture on AWS using Terraform. It demonstrates enterprise-level network security practices including network segmentation, defence-in-depth security, and comprehensive monitoring.

**Key Highlights**
**Multi-tier Architecture:** Public, Private, and Database subnet layers
**High Availability:** Resources deployed across 2 Availability Zones
**Defence in Depth:** Multiple security layers (NACLs, Security Groups, Flow Logs)
**Full Observability:** VPC Flow Logs with CloudWatch integration
**Infrastructure as Code:** 100% automated with Terraform
**Cost Optimized:** Optional NAT Gateway deployment for dev environments

------
## Architecture Overview

This project implements a three-tier network architecture with:

- **Public Tier**: Internet-facing resources (NAT Gateways, Load Balancers)
- **Private Tier**: Application servers (no direct internet access)
- **Database Tier**: Data layer (fully isolated)

 **Architecture Diagram**

<img width="700" height="400" alt="gemini-3-pro-image-preview-2k (nano-banana-pro)_b_Create_a_professiona" src="https://github.com/user-attachments/assets/26f9216f-c858-4d81-81de-f44eda7f0970" />

-------

## Features
**Network Architecture**
VPC: Isolated virtual network (10.0.0.0/16)
6 Subnets: 2 public, 2 private, 2 database (across 2 AZs)
Internet Gateway: Public internet access for public subnets
2 NAT Gateways: Secure outbound internet for private subnets
7 Route Tables: Proper traffic routing per subnet tier
Multi-AZ Deployment: High availability and fault tolerance

**Security Features**
Security Group Chaining: Least-privilege access between tiers
Network ACLs: Stateless subnet-level firewall rules
VPC Flow Logs: Complete network traffic visibility
Private Subnets: No direct internet access for sensitive workloads
Database Isolation: Completely isolated database tier
Defence in Depth: Multiple overlapping security controls

**Monitoring & Compliance**
VPC Flow Logs: All network traffic logged to CloudWatch
CloudWatch Integration: 30-day log retention
IAM Roles: Least-privilege permissions for logging
Tagging Strategy: Comprehensive resource tagging

**Infrastructure as Code**
Terraform Modules: Reusable, modular code
Variables: Easy customization via terraform.tfvars
Outputs: Export values for integration
State Management: Terraform state tracking
Version Control: Git-friendly structure

-----
## Prerequisites
**Required Tools**
|Tool|	Version|	Purpose|
|----|---------|---------|
|Terraform|	≥ 1.0|	Infrastructure provisioning|
|AWS CLI|	≥ 2.0	AWS| authentication|
|Git|	Latest	|Version control|

**AWS Requirements**
AWS Account with administrative access
AWS CLI configured with credentials
**Permissions to create:**
VPC, Subnets, Route Tables
Internet Gateway, NAT Gateway
Security Groups, Network ACLs
CloudWatch Logs, IAM Roles
Elastic IPs

**Verify Prerequisites**
```bash

# Check Terraform version
terraform --version

# Check AWS CLI version
aws --version

# Verify AWS credentials
aws sts get-caller-identity

# Check configured region
aws configure get region
```
-----
## Quick Start
**1. Clone Repository**

```bash

git clone https://github.com/YOUR-USERNAME/secure-vpc-project.git
cd secure-vpc-project
```

**2. Configure Variables (Optional)**
```bash

# Copy example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit with your preferences
nano terraform.tfvars
```
**3. Initialize Terraform**
```bash
terraform init
```
**4. Preview Changes**
```bash
terraform plan
```

**5. Deploy Infrastructure**
```bash
terraform apply
```
Type yes when prompted.

**6. View Outputs**
```bash
terraform output
```

**7. Clean Up (When Done)**
```bash

terraform destroy
```
Type yes when prompted.

----
## Project Structure
```bash
secure-vpc-project/
├── README.md                 # This file
├── LICENSE                   # MIT License
├── .gitignore               # Git ignore rules
├── provider.tf              # AWS provider configuration
├── variables.tf             # Input variables
├── main.tf                  # VPC, subnets, gateways
├── routing.tf               # Route tables and associations
├── security.tf              # Security groups
├── nacl.tf                  # Network ACLs
├── monitoring.tf            # VPC Flow Logs
├── outputs.tf               # Output values
├── terraform.tfvars.example # Example variables file
└── docs/
    ├── architecture.png     # Architecture diagram
    └── deployment-guide.md  # Detailed deployment guide
  ```  
----
## Detailed Configuration
**Variables Reference**
|Variable|	Type|	Default|	Description|
|--------|------|--------|-------------|
|aws_region|	string|	us-east-1	AWS| region for deployment|
|environment|	string|	dev|	Environment name (dev/staging/prod)|
|project_name|	string|	secure-vpc|	Project name for resource naming|
|vpc_cidr|	string|	10.0.0.0/16|	VPC CIDR block (65,536 IPs)|
|availability_zones|	list(string)|	["us-east-1a", "us-east-1b"]|	AZs for subnet deployment|
|public_subnet_cidrs|	list(string)|	["10.0.1.0/24", "10.0.2.0/24"]| Public subnet CIDRs (256 IPs each)|
|private_subnet_cidrs|	list(string)|	["10.0.11.0/24", "10.0.12.0/24"]|	Private subnet CIDRs|
|database_subnet_cidrs|	list(string)|	["10.0.21.0/24", "10.0.22.0/24"]|	Database subnet CIDRs|
|enable_nat_gateway|	bool |true| Enable NAT Gateways (incurs cost)|
|enable_flow_logs|	bool|	true|	Enable VPC Flow Logs|

**Example terraform.tfvars**
```bash

aws_region         = "us-east-1"
environment        = "dev"
project_name       = "secure-vpc"
enable_nat_gateway = false  # Set to false for cost savings
enable_flow_logs   = true
# Optional: Customize CIDR blocks
# vpc_cidr = "10.1.0.0/16"
# public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
```
**Outputs Reference**
|Outputs| Description|
|-------|----------|
|vpc_id|	VPC identifier|
|vpc_cidr|	VPC CIDR block|
|public_subnet_ids|	List of public subnet IDs|
|private_subnet_ids|	List of private subnet IDs|
|database_subnet_ids|	List of database subnet IDs|
|alb_security_group_id|	ALB security group ID|
|app_security_group_id|	Application security group ID|
|database_security_group_i	Database security group ID|
|nat_gateway_ips|Elastic IPs of NAT Gateways|
|flow_log_group_name|CloudWatch Log Group name|

-----
## Security Implementation
**Defence-in-Depth Strategy**
This project implements three layers of security:

**Layer 1: Network ACLs (Subnet-level)**
**Public Subnet NACL:**
```bash


Inbound:
  Rule 100: Allow HTTP (80) from 0.0.0.0/0
  Rule 110: Allow HTTPS (443) from 0.0.0.0/0
  Rule 120: Allow ephemeral ports (1024-65535) from 0.0.0.0/0

Outbound:
  Rule 100: Allow all traffic to 0.0.0.0/0
```
**Private Subnet NACL:*
```bash

Inbound:
  Rule 100: Allow all from VPC (10.0.0.0/16)
  Rule 110: Allow ephemeral ports from 0.0.0.0/0

Outbound:
  Rule 100: Allow all traffic
```

**Database Subnet NACL:**
```bash

Inbound:
  Rule 100: Allow all from VPC (10.0.0.0/16) only

Outbound:
  Rule 100: Allow all to VPC (10.0.0.0/16) only
Layer 2: Security Groups (Instance-level)
```

**ALB Security Group:**
Inbound: Port 443 (HTTPS) from 0.0.0.0/0
Inbound: Port 80 (HTTP) from 0.0.0.0/0
Outbound: All traffic

**App Security Group:**
Inbound: Port 8080 from ALB Security Group only
Outbound: All traffic

**Database Security Group:**
Inbound: Port 5432 (PostgreSQL) from App Security Group only
Outbound: All traffic

**Security Group Chaining:**
```bash
Internet → ALB SG → App SG → DB SG
```
**Layer 3: VPC Flow Logs**
**What's Logged:**
Source/Destination IP addresses
Source/Destination ports
Protocol (TCP/UDP/ICMP)
Packet and byte counts
Action (ACCEPT/REJECT)
Log status

**Sample Flow Log Entry:**

```bash

2 123456789010 eni-abc123 10.0.1.5 10.0.11.10 443 8080 6 15 6000 1234567890 1234567920 ACCEPT OK
```

**Use Cases:**
Detect unauthorized access attempts
Troubleshoot connectivity issues
Compliance auditing (PCI-DSS, HIPAA, SOC 2)
Security incident investigation

**Security Best Practices Implemented**
Least Privilege: Security groups only allow necessary traffic
Network Segmentation: Three distinct tiers with isolation
No Direct Internet Access: Private/DB subnets use NAT Gateway
Monitoring: All traffic logged for analysis
Multi-AZ: No single point of failure
Encryption Ready: VPC supports encryption at rest/in transit
Bastion Host Ready: Security group prepared for jump box

-------
## Cost Estimation
**Monthly Cost Breakdown (us-east-1)**
|Resource|	Quantity|Unit Cost|	Monthly Cost|
|--------|----------|---------|-------------|
|VPC|	1|	$0.00|	$0.00|
|Subnets|	6|	$0.00|	$0.00|
|Internet Gateway|	1| $0.00|	$0.00|
|Route Tables|	7|	$0.00|	$0.00|
|Security Groups|	4|	$0.00|	$0.00|
|Network ACLs|	3|	$0.00|	$0.00|
|NAT Gateway|	2|	$0.045/hr|	$64.80|
|Elastic IPs|	2|	$0.00 (attached)|	$0.00|
|VPC Flow Logs|	|-|	~$0.50/GB|	$5-10|
|CloudWatch Logs|	-|	$0.03/GB (storage)|	$2-5|
| | |TOTAL|	~$72-80/month
Cost Optimization Strategies
Development/Testing (Minimal Cost)
hcl

# In terraform.tfvars
enable_nat_gateway = false  # Saves ~$65/month
enable_flow_logs   = false  # Saves ~$7/month
Dev Environment Cost: ~$0/month (only free-tier resources)

Production (Full Features)
hcl

enable_nat_gateway = true   # Required for security
enable_flow_logs   = true   # Required for compliance
Production Cost: ~$75/month

Additional Cost Considerations
NAT Gateway Data Processing: $0.045 per GB processed
Data Transfer: $0.09 per GB outbound (after 1 GB free)
CloudWatch Logs Ingestion: First 5GB free, then $0.50/GB
Flow Logs Storage: $0.03 per GB stored
Cost Monitoring
Bash

# View estimated costs before deployment
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan | jq '.resource_changes'

# AWS Cost Explorer (after deployment)
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics "BlendedCost" "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE
📖 Deployment Guide
Step-by-Step Deployment
Step 1: Preparation
Bash

# Clone repository
git clone https://github.com/YOUR-USERNAME/secure-vpc-project.git
cd secure-vpc-project

# Configure AWS credentials (if not already done)
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter default region (e.g., us-east-1)
# Enter default output format (json)

# Verify AWS credentials
aws sts get-caller-identity
Step 2: Initialize Terraform
Bash

# Download provider plugins and initialize backend
terraform init

# Expected output:
# Terraform has been successfully initialized!
Step 3: Validate Configuration
Bash

# Check syntax and configuration
terraform validate

# Expected output:
# Success! The configuration is valid.
Step 4: Review Execution Plan
Bash

# Preview changes
terraform plan

# Review the output:
# - 1 VPC to be created
# - 6 Subnets to be created
# - 2 NAT Gateways to be created
# - Security groups, route tables, etc.
Key things to verify in plan:

✅ VPC CIDR: 10.0.0.0/16
✅ Subnets: 6 total (2 per tier, 2 AZs)
✅ NAT Gateways: 2 (one per AZ)
✅ Security Groups: 4 (ALB, App, DB, Bastion)
✅ Flow Logs: Enabled
Step 5: Deploy Infrastructure
Bash

# Apply configuration
terraform apply

# Review the plan one more time
# Type 'yes' to confirm

# Wait 3-5 minutes for creation
Deployment Timeline:

VPC, Subnets, IGW: ~30 seconds
NAT Gateways, EIPs: ~2-3 minutes
Security Groups, NACLs: ~30 seconds
Flow Logs, IAM: ~1 minute
Step 6: Verify Outputs
Bash

# Display all outputs
terraform output

# Display specific output
terraform output vpc_id
terraform output public_subnet_ids

# Export output to file
terraform output -json > outputs.json
AWS Console Verification
1. VPC Verification
text

1. Go to AWS Console → VPC Dashboard
2. Click "Your VPCs"
3. Find: secure-vpc-dev
4. Verify:
   ✅ CIDR: 10.0.0.0/16
   ✅ DNS hostnames: Enabled
   ✅ DNS resolution: Enabled
2. Subnet Verification
text

1. Click "Subnets"
2. Filter by VPC: secure-vpc-dev
3. Verify 6 subnets:
   ✅ public-subnet-1 (10.0.1.0/24, us-east-1a)
   ✅ public-subnet-2 (10.0.2.0/24, us-east-1b)
   ✅ private-subnet-1 (10.0.11.0/24, us-east-1a)
   ✅ private-subnet-2 (10.0.12.0/24, us-east-1b)
   ✅ database-subnet-1 (10.0.21.0/24, us-east-1a)
   ✅ database-subnet-2 (10.0.22.0/24, us-east-1b)
3. NAT Gateway Verification
text

1. Click "NAT Gateways"
2. Verify 2 NAT Gateways:
   ✅ nat-gateway-1 in public-subnet-1
   ✅ nat-gateway-2 in public-subnet-2
   ✅ Status: Available
   ✅ Each has an Elastic IP
4. Route Table Verification
text

1. Click "Route Tables"
2. Filter by VPC
3. Verify routing:

Public Route Table:
   ✅ 0.0.0.0/0 → Internet Gateway
   ✅ Associated with public subnets

Private Route Tables (2):
   ✅ 0.0.0.0/0 → NAT Gateway (respective AZ)
   ✅ Associated with private subnets

Database Route Tables (2):
   ✅ Only local route (10.0.0.0/16)
   ✅ No internet route
5. Security Group Verification
text

1. Click "Security Groups"
2. Find 4 security groups
3. Verify rules:

ALB Security Group:
   Inbound:
   ✅ Port 443 from 0.0.0.0/0
   ✅ Port 80 from 0.0.0.0/0

App Security Group:
   Inbound:
   ✅ Port 8080 from ALB SG only

Database Security Group:
   Inbound:
   ✅ Port 5432 from App SG only
6. VPC Flow Logs Verification
text

1. Go to CloudWatch → Log Groups
2. Find: /aws/vpc/flow-logs/secure-vpc-dev
3. Verify:
   ✅ Log group exists
   ✅ Retention: 30 days
   ✅ Log streams appear (after 5-10 min)












## Deployment

 **Prerequisites**
- AWS Account with appropriate permissions
- Terraform >= 1.0
- AWS CLI configured with credentials

**Steps**

**1. Clone the repository**
```bash
git clone https://github.com/Terraform/secure-vpc-project.git
cd secure-vpc-project
```
**2. Initialize Terraform**
```bash
terraform init
```
**3. Review the plan**
```bash
terraform plan
```
**4. Deploy infrastructure**
```bash
terraform apply
```
**Verify in AWS Console**
VPC Dashboard: Confirm VPC creation
Subnets: Verify 6 subnets across 2 AZs
Route Tables: Check routing configuration
Security Groups: Validate security group rules
CloudWatch: Check VPC Flow Logs

**Clean Up**

```bash
terraform destroy
```
-----
## Cost Considerations

|Resource|	Estimated Monthly Cost|
|--------|------------------------|
|NAT Gateway (×2)|	~$64|
|VPC Flow Logs (CloudWatch)|	~$5-10|
|VPC, Subnets, IGW, Route Tables, SGs|	$0|
|Total	|~$70-75/month|

**Cost Optimization Tips:**
Set enable_nat_gateway = false for development
Adjust Flow Logs retention period
Use VPC endpoints for AWS services to reduce NAT Gateway traffic

-----
## Resources Created
1 VPC
6 Subnets (2 public, 2 private, 2 database)
1 Internet Gateway
2 NAT Gateways
2 Elastic IPs
7 Route Tables
4 Security Groups
3 Network ACLs
VPC Flow Logs (CloudWatch Log Group + IAM Role)

-----
## Learning Outcomes
This project demonstrates:
Network Architecture: Multi-tier VPC design
High Availability: Multi-AZ deployment
Security Best Practices: Defense in depth, least privilege
Infrastructure as Code: Terraform modules and resources
AWS Networking: VPC, subnets, routing, NAT, security groups
Monitoring: VPC Flow Logs for network visibility

----
