# Secure VPC Architecture - AWS Terraform Project

A production-grade, secure VPC implementation on AWS using Terraform that demonstrates defence-in-depth network security principles.

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform)](https://www.terraform.io/) 
[![AWS VPC](https://img.shields.io/badge/AWS-VPC-FF9900?logo=amazonaws)](https://aws.amazon.com/vpc/) 
[![Security](https://img.shields.io/badge/Security-Production%20Grade-success)]() 
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE) 
[![Security Groups](https://img.shields.io/badge/Security%20Groups-Defense%20in%20Depth-orange)]() 
[![Flow Logs](https://img.shields.io/badge/Flow%20Logs-Enabled-blueviolet)]() 
[![Multi-AZ](https://img.shields.io/badge/Multi--AZ-High%20Availability-green)]()

-----
## Full Architecture Walkthrough & Production Deployment  

**Click the image below to watch the complete implementation on YouTube:**

<a href="https://www.youtube.com/watch?v=" target="_blank">
  <img src="https://img.youtube.com/vi//maxresdefault.jpg" 
       width="700" 
       height="400" 
       alt="Secure VPC Architecture - AWS Terraform Project">
</a>

-------
# Table of Contents

- [Overview](#overview)
- [Architecture Overview](#architecture-overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#Quick-Start)
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
# Overview
This project implements a **three-tier, highly available VPC architecture** on AWS using Terraform. It demonstrates enterprise-level network security practices, including network segmentation, defence-in-depth security, and comprehensive monitoring.

**Key Highlights** <br>
- **Multi-tier Architecture:** Public, Private, and Database subnet layers <br>
- **High Availability:** Resources deployed across 2 Availability Zones <br>
- **Defence in Depth:** Multiple security layers (NACLs, Security Groups, Flow Logs) <br>
- **Full Observability:** VPC Flow Logs with CloudWatch integration <br>
- **Infrastructure as Code:** 100% automated with Terraform <br>
- **Cost Optimised:** Optional NAT Gateway deployment for dev environments

------
# Architecture Overview

This project implements a three-tier network architecture with: <br>

- **Public Tier**: Internet-facing resources (NAT Gateways, Load Balancers) <br>
- **Private Tier**: Application servers (no direct internet access) <br>
- **Database Tier**: Data layer (fully isolated)

 ### Architecture Diagram

<img width="700" height="400" alt="gemini-3-pro-image-preview-2k (nano-banana-pro)_b_Create_a_professiona" src="https://github.com/user-attachments/assets/26f9216f-c858-4d81-81de-f44eda7f0970" />

-------
# Features
**Network Architecture** <br>
- **VPC:** Isolated virtual network (10.0.0.0/16) <br>
- **6 Subnets:** 2 public, 2 private, 2 database (across 2 AZs) <br>
- **Internet Gateway:** Public internet access for public subnets <br>
- **2 NAT Gateways:** Secure outbound internet for private subnets <br>
- **7 Route Tables:** Proper traffic routing per subnet tier <br>
- **Multi-AZ Deployment:** High availability and fault tolerance

**Security Features** <br>
- **Security Group Chaining**: ALB → App → DB (Least-privilege access between tiers) <br>
- **Network ACLs:** Stateless subnet-level firewall rules <br>
- **VPC Flow Logs:** Complete network traffic visibility <br>
- **Private Subnets:** No direct internet access for sensitive workloads <br>
- **Database Isolation:** Completely isolated database tier <br>
- **Defence in Depth:** Multiple overlapping security controls

**Monitoring & Compliance** <br>
- **VPC Flow Logs:** All network traffic logged to CloudWatch <br>
- **CloudWatch Integration:** 30-day log retention <br>
- **IAM Roles:** Least-privilege permissions for logging <br>
- **Tagging Strategy:** Comprehensive resource tagging

**Infrastructure as Code** <br>
- **Terraform Modules:** Reusable, modular code <br>
- **Variables:** Easy customization via terraform.tfvars <br>
- **Outputs:** Export values for integration <br>
- **State Management:** Terraform state tracking <br>
- **Version Control:** Git-friendly structure

-----
## Prerequisites
**Required Tools**
|Tool|	Version|	Purpose|
|----|---------|---------|
|Terraform|	≥ 1.0|	Infrastructure provisioning|
|AWS CLI|	≥ 2.0	|AWS authentication|
|Git|	Latest | Version control|

**AWS Requirements**
- AWS Account with administrative access
- AWS CLI configured with credentials
  **Permissions to create:**
   - VPC, Subnets, Route Tables
   - Internet Gateway, NAT Gateway
   - Security Groups, Network ACLs
   - CloudWatch Logs, IAM Roles
   - Elastic IPs

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
Type **yes** when prompted.

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
|alb_sg_id|	ALB security group ID|
|app_sg_id | Application security group ID |
| db_sg_id | Database security group ID |
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
**Private Subnet NACL:**
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
- Inbound: Port 443 (HTTPS) from 0.0.0.0/0
- Inbound: Port 80 (HTTP) from 0.0.0.0/0
- Outbound: All traffic
  
**App Security Group:**
- Inbound: Port 8080 from ALB Security Group only
- Outbound: All traffic

**Database Security Group:**
- Inbound: Port 5432 (PostgreSQL) from App Security Group only
- Outbound: All traffic

**Security Group Chaining:**
```bash
Internet → ALB SG → App SG → DB SG
```
**Layer 3: VPC Flow Logs**
**What's Logged:**
- Source/Destination IP addresses
- Source/Destination ports
- Protocol (TCP/UDP/ICMP)
- Packet and byte counts
- Action (ACCEPT/REJECT)
- Log status

**Sample Flow Log Entry:**

```bash

2 123456789010 eni-abc123 10.0.1.5 10.0.11.10 443 8080 6 15 6000 1234567890 1234567920 ACCEPT OK
```

**Use Cases:**
- Detect unauthorised access attempts
- Troubleshoot connectivity issues
- Compliance auditing (PCI-DSS, HIPAA, SOC 2)
- Security incident investigation

**Security Best Practices Implemented** <br>
**Least Privilege:** Security groups only allow necessary traffic <br>
**Network Segmentation:** Three distinct tiers with isolation <br>
**No Direct Internet Access:** Private/DB subnets use NAT Gateway <br>
**Monitoring:** All traffic logged for analysis <br>
**Multi-AZ:** No single point of failure <br>
**Encryption Ready:** VPC supports encryption at rest/in transit <br>
**Bastion Host Ready:** Security group prepared for jump box

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
|VPC Flow Logs|	-|	~$0.50/GB|	$5-10|
|CloudWatch Logs|	-|	$0.03/GB (storage)|	$2-5|
| | |TOTAL|	~$72-80/month


**Cost Optimisation Strategies**
**Development/Testing (Minimal Cost)**
```bash

#In terraform.tfvars
enable_nat_gateway = false  # Saves ~$65/month
enable_flow_logs   = false  # Saves ~$7/month
```
**Dev Environment Cost: ~$0/month (only free-tier resources)**

**Production (Full Features)**
```bash

enable_nat_gateway = true   # Required for security
enable_flow_logs   = true   # Required for compliance
```
**Production Cost: ~$75/month**

**Additional Cost Considerations** <br>
- **NAT Gateway Data Processing:** $0.045 per GB processed <br>
- **Data Transfer:** $0.09 per GB outbound (after 1 GB free) <br>
- **CloudWatch Logs Ingestion:** First 5GB free, then $0.50/GB <br>
- **Flow Logs Storage:** $0.03 per GB stored

**Cost Monitoring**
```bash

# View estimated costs before deployment
terraform plan -out=plan.tfplan
terraform show -json plan.tfplan | jq '.resource_changes'

# AWS Cost Explorer (after deployment)
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics "BlendedCost" "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE
```
-----
# Deployment Guide
**Step-by-Step Deployment** <br>
**Step 1: Preparation**

```bash
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
```

**Step 2: Initialize Terraform**
```bash

# Download provider plugins and initialize backend
terraform init

# Expected output:
# Terraform has been successfully initialized!
```
**Step 3: Validate Configuration**
```bash

# Check syntax and configuration
terraform validate

# Expected output:
# Success! The configuration is valid.
```
**Step 4: Review Execution Plan**
```bash

# Preview changes
terraform plan

# Review the output:
# - 1 VPC to be created
# - 6 Subnets to be created
# - 2 NAT Gateways to be created
# - Security groups, route tables, etc.
```
**Key things to verify in plan:**
- **VPC CIDR:** 10.0.0.0/16
- **Subnets:** 6 total (2 per tier, 2 AZs)
- **NAT Gateways:** 2 (one per AZ)
- **Security Groups:** 4 (ALB, App, DB, Bastion)
- **Flow Logs:** Enabled

**Step 5: Deploy Infrastructure**
```bash

Key things to verify in plan:

# VPC CIDR: 10.0.0.0/16
# Subnets: 6 total (2 per tier, 2 AZs)
# NAT Gateways: 2 (one per AZ)
# Security Groups: 3 (ALB, App, DB)
# Flow Logs: Enabled
```
**Deployment Timeline:**

- **VPC, Subnets, IGW:** ~30 seconds
- **NAT Gateways, EIPs:** ~2-3 minutes
- **Security Groups, NACLs:** ~30 seconds
- **Flow Logs, IAM:** ~1 minute


**Step 6: Verify Outputs**
```bash

# Display all outputs
terraform output

# Display specific output
terraform output vpc_id
terraform output public_subnet_ids

# Export output to file
terraform output -json > outputs.json
```

**AWS Console Verification**
**1. VPC Verification**
```bash

1. Go to AWS Console → VPC Dashboard
2. Click "Your VPCs"
3. Find: secure-vpc-dev
4. Verify:
   CIDR: 10.0.0.0/16
   DNS hostnames: Enabled
   DNS resolution: Enabled
```
**2. Subnet Verification**
```bash

1. Click "Subnets"
2. Filter by VPC: secure-vpc-dev
3. Verify 6 subnets:
   public-subnet-1 (10.0.1.0/24, us-east-1a)
   public-subnet-2 (10.0.2.0/24, us-east-1b)
   private-subnet-1 (10.0.11.0/24, us-east-1a)
   private-subnet-2 (10.0.12.0/24, us-east-1b)
   database-subnet-1 (10.0.21.0/24, us-east-1a)
   database-subnet-2 (10.0.22.0/24, us-east-1b)
```
**3. NAT Gateway Verification**
```bash

1. Click "NAT Gateways"
2. Verify 2 NAT Gateways:
   nat-gateway-1 in public-subnet-1
   nat-gateway-2 in public-subnet-2
   Status: Available
   Each has an Elastic IP
```
**4. Route Table Verification**
```bash

1. Click "Route Tables"
2. Filter by VPC
3. Verify routing:

Public Route Table:
   0.0.0.0/0 → Internet Gateway
   Associated with public subnets

Private Route Tables (2):
   0.0.0.0/0 → NAT Gateway (respective AZ)
   Associated with private subnets

Database Route Tables (2):
   Only local route (10.0.0.0/16)
   No internet route
```
**5. Security Group Verification**
```bash

5. Security Group Verification

1. Click "Security Groups"
2. Find 3 security groups
3. Verify rules:

ALB Security Group:
   Inbound:
    Port 443 from 0.0.0.0/0
    Port 80 from 0.0.0.0/0

App Security Group:
   Inbound:
    Port 8080 from ALB SG only

Database Security Group:
   Inbound:
    Port 5432 from App SG only
```

**6. VPC Flow Logs Verification**
```bash

1. Go to CloudWatch → Log Groups
2. Find: /aws/vpc/flow-logs/secure-vpc-dev
3. Verify:
   Log group exists
   Retention: 30 days
   Log streams appear (after 5-10 min)
```
----
 # Verification Steps
**Automated Tests**
Create ```tests/verify.sh:```

```bash

#!/bin/bash

echo "🔍 Verifying VPC Architecture..."

# Get VPC ID from Terraform
VPC_ID=$(terraform output -raw vpc_id)

# Test 1: VPC exists
echo "✓ Testing VPC existence..."
aws ec2 describe-vpcs --vpc-ids $VPC_ID > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   VPC exists: $VPC_ID"
else
    echo "   VPC not found"
    exit 1
fi

# Test 2: Count subnets
echo "✓ Testing subnet count..."
SUBNET_COUNT=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].SubnetId' --output text | wc -w)
if [ $SUBNET_COUNT -eq 6 ]; then
    echo "   Found 6 subnets"
else
    echo "   Expected 6 subnets, found $SUBNET_COUNT"
fi

# Test 4: Security Groups
echo "✓ Testing Security Groups..."
SG_COUNT=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text | wc -w)
if [ $SG_COUNT -eq 3 ]; then
    echo "   Found 3 custom security groups"
else
    echo "   Expected 3 security groups, found $SG_COUNT"
fi

# Test 4: Security Groups
echo "✓ Testing Security Groups..."
SG_COUNT=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text | wc -w)
if [ $SG_COUNT -eq 4 ]; then
    echo "   Found 4 custom security groups"
else
    echo "   Expected 4 security groups, found $SG_COUNT"
fi

# Test 5: Internet Gateway
echo "✓ Testing Internet Gateway..."
IGW_COUNT=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query 'InternetGateways[*].InternetGatewayId' --output text | wc -w)
if [ $IGW_COUNT -eq 1 ]; then
    echo "   Found Internet Gateway"
else
    echo "   Internet Gateway not found"
fi

echo ""
echo " Verification complete!"
```
**Run verification:**

```bash

chmod +x tests/verify.sh
./tests/verify.sh
```
**Manual Verification Checklist**
```bash

□ VPC created with correct CIDR (10.0.0.0/16)
□ 6 subnets created (2 public, 2 private, 2 database)
□ Subnets distributed across 2 AZs
□ Internet Gateway attached to VPC
□ 2 NAT Gateways in public subnets
□ Public subnets route to Internet Gateway
□ Private subnets route to NAT Gateways
□ Database subnets have no internet route
□ 3 Security Groups created with correct rules (ALB, App, DB)
□ 3 Network ACLs configured
□ VPC Flow Logs enabled and logging to CloudWatch
□ All resources properly tagged
```
-----
# Cleanup
**Complete Cleanup**
```bash

# Destroy all resources
terraform destroy

# Review destruction plan
# Type 'yes' to confirm

# Wait 3-5 minutes for deletion
```
**Verify Cleanup**
```bash

# Check if VPC still exists (should return empty)
VPC_ID=$(terraform output -raw vpc_id 2>/dev/null)
aws ec2 describe-vpcs --vpc-ids $VPC_ID 2>&1 | grep -q "InvalidVpcID.NotFound"
if [ $? -eq 0 ]; then
    echo "VPC successfully deleted"
else
    echo "VPC may still exist"
fi
```
**Manual Cleanup (if needed)**
If terraform destroy fails:

```bash

# 1. Delete NAT Gateways manually
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" --query 'NatGateways[*].NatGatewayId' --output text | \
xargs -I {} aws ec2 delete-nat-gateway --nat-gateway-id {}

# 2. Wait 5 minutes for NAT Gateways to delete

# 3. Release Elastic IPs
aws ec2 describe-addresses --filters "Name=domain,Values=vpc" --query 'Addresses[*].AllocationId' --output text | \
xargs -I {} aws ec2 release-address --allocation-id {}

# 4. Try terraform destroy again
terraform destroy
```

**AWS Console Cleanup Verification**
```bash

1. VPC Dashboard → Your VPCs
   secure-vpc-dev should be gone

2. Subnets
   All 6 subnets deleted

3. NAT Gateways
   Both NAT Gateways are deleted or are being deleted

4. Elastic IPs
   No unattached EIPs

5. Security Groups
   - All 3 custom security groups (ALB, App, DB) deleted
   - Only the default SG remains

6. CloudWatch → Log Groups
   Flow log group deleted
```
----
# Troubleshooting
**Common Issues and Solutions**
**Issue 1: NAT Gateway Quota Exceeded**
**Error:**
```bash

Error: Error creating NAT Gateway: NatGatewayLimitExceeded
```
**Solution:**

```bash

# Check current NAT Gateway usage
aws ec2 describe-nat-gateways --query 'NatGateways[?State==`available`]' --output table

# Request quota increase
aws service-quotas request-service-quota-increase \
  --service-code vpc \
  --quota-code L-FE5A380F \
  --desired-value 10

# OR disable NAT Gateways for dev
# In terraform.tfvars:
enable_nat_gateway = false
```
**Issue 2: Terraform State Lock**
**Error:**

```bash

Error: Error acquiring the state lock
```
**Solution:**

```bash

# If using local state
rm -rf .terraform/terraform.tfstate.lock.info

# If using remote state (S3)
aws dynamodb delete-item \
  --table-name terraform-state-lock \
  --key '{"LockID": {"S": "your-state-bucket/terraform.tfstate"}}'
```

**Issue 3: Insufficient IAM Permissions**
**Error:**

```bash

Error: UnauthorizedOperation: You are not authorized to perform this operation
```
**Solution:**

```bash

// Required IAM permissions (attach to your user/role)
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "logs:*",
        "iam:CreateRole",
        "iam:PutRolePolicy",
        "iam:AttachRolePolicy"
      ],
      "Resource": "*"
    }
  ]
}
```
**Issue 4: Destroy Fails Due to Dependencies**
**Error:**
```bash

Error: error deleting VPC: DependencyViolation
```
**Solution:**

```bash

# 1. Delete NAT Gateways first (they take longest)
terraform destroy -target=aws_nat_gateway.main
terraform destroy -target=aws_eip.nat

# 2. Wait 5 minutes

# 3. Destroy everything else
terraform destroy
```

**Issue 5: Flow Logs Not Appearing**
**Issue:** VPC Flow Logs enabled but no logs in CloudWatch

**Solution:**

```bash

# Wait 10-15 minutes for first logs to appear

# Check IAM role permissions
aws iam get-role-policy \
  --role-name $(terraform output -raw flow_log_role_name) \
  --policy-name VPCFlowLogsPolicy

# Check Flow Log status
aws ec2 describe-flow-logs --filter "Name=resource-id,Values=$(terraform output -raw vpc_id)"

# Generate some traffic to trigger logs
# Launch a test EC2 instance and ping google.com
```

**Debug Mode** <br>
Enable Terraform debug logging:

```bash

export TF_LOG=DEBUG
export TF_LOG_PATH=terraform-debug.log

terraform apply

# View logs
cat terraform-debug.log
```
------
# Learning Outcomes
**Skills Demonstrated**
By completing this project, you demonstrate proficiency in:

**AWS Networking** 
- VPC design and architecture <br>
- Subnet planning and CIDR notation <br>
- Routing and route table configuration <br>
- Internet Gateway and NAT Gateway usage <br>
- Multi-AZ deployment strategies
  
**Security**
- Defense-in-depth principles
- Security group chaining
- Network ACL configuration
- Least privilege access control
- Network segmentation
  
**Monitoring & Compliance**
- VPC Flow Logs implementation
- CloudWatch Logs integration
- Security monitoring and auditing
- Compliance logging (PCI-DSS, HIPAA)
  
**Infrastructure as Code**
- Terraform best practices
- Module organisation
- Variable management
- State management
- Resource dependencies
  
**Cloud Architecture**
- High availability design
- Fault tolerance
- Scalability considerations
- Cost optimization
-----

# License
This project is licensed under the MIT License
```bash

MIT License

Copyright (c) 2025 [Adeoye Emmanuel Eniola]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
-----
# **👤** Author
**Adeoye Emmanuel** - AWS Certified Solutions Architect | AWS Security Solutions Architect | DevSecOps Engineer

**Email:** Emmanuelofgrace@gmail.com

💼 LinkedIn: www.linkedin.com/in/emmanuel-adeoye-29187bb7

