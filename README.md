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
|Outputs| Reference|
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
