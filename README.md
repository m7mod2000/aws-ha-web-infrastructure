# 🌐 Enterprise Multi-VPC Web Infrastructure on AWS (Transit Gateway & EFS)

[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![Linux](https://img.shields.io/badge/OS-Amazon%20Linux%202023-yellow?logo=linux)](https://al2023.aws/)
[![Topology](https://img.shields.io/badge/Topology-Hub%20%26%20Spoke%20(TGW)-blue)](#)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](#)

---

## 📌 Executive Summary
This project demonstrates the design, deployment, and end-to-end verification of an enterprise-grade, highly available multi-tier cloud infrastructure on Amazon Web Services (AWS). 

The architecture interconnects three dedicated Virtual Private Clouds (VPCs) using a centralized **AWS Transit Gateway (Hub-and-Spoke)** topology, backed by an **Auto Scaling Group (ASG)** across multiple Availability Zones and a shared persistent storage layer using **Amazon EFS**.

---

## 🏗️ High-Level Architectural Highlights

1. **Multi-VPC Interconnectivity (AWS Transit Gateway):**
   - Centralized network hub connecting three dedicated VPCs (`project-1`, `project-2`, `project-3`) via VPC attachments.
   - Simplified routing management eliminating complex full-mesh peering connections.
2. **Compute & Auto Scaling:**
   - Stateless compute instances running **Amazon Linux 2023** managed by an Auto Scaling Group across private subnets.
   - Configured via EC2 Launch Templates executing custom bootstrap automation (`scripts/setup-ec2.sh`).
3. **Traffic Distribution (ALB):**
   - Internet-facing Application Load Balancer performing HTTP Layer-7 Health Checks (`/`) across dynamic target instances.
4. **Shared Persistent Storage (Amazon EFS):**
   - Multi-AZ Amazon Elastic File System mounted across instances via NFS (port 2049) over TLS.
   - Shared web root (`/mnt/efs` symlinked to `/var/www/html`) eliminating web content drift.
5. **Principle of Least Privilege Security:**
   - Strict layered Security Groups restricting ingress: `Public -> ALB -> Web SG -> EFS NFS SG`.

---

## ⚙️ Automated Bootstrapping & Scripting
All EC2 instances are dynamically initialized using the launch script:
📁 [`scripts/setup-ec2.sh`](scripts/setup-ec2.sh)

The script automatically:
- Updates package repos via `dnf`.
- Installs Apache (`httpd`) and Amazon EFS utilities (`amazon-efs-utils`).
- Mounts the shared EFS filesystem using TLS encryption.
- Links the EFS mount directory to `/var/www/html`.

---

## 📸 Architecture & Implementation Proof

### 1. Network Topology (AWS Transit Gateway Attachments)
![Transit Gateway Attachments](01-transit-gateway-attachments.png)

### 2. Centralized Routing Table
![Transit Gateway Route Table](02-tgw-route-table.png)

### 3. Multi-VPC Environment
![Multi-VPC List](03-multi-vpc-list.png)

### 4. Amazon EFS Multi-AZ Mount Targets
![EFS Mount Targets](04-efs-mount-targets.png)

### 5. Auto Scaling Group Fleet
![ASG InService Instances](05-asg-instances-inservice.png)

### 6. ALB Target Group Health Verification
![ALB Target Group Healthy](06-alb-target-group-healthy.png)

### 7. End-to-End Live Web Verification
![Browser Verification](07-browser-efs-output.png)
