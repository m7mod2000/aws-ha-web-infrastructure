# 🌐 Highly Available & Scalable Multi-AZ Web Infrastructure on AWS

[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![Linux](https://img.shields.io/badge/OS-Amazon%20Linux%202023-yellow?logo=linux)](https://al2023.aws/)
[![Status](https://img.shields.io/badge/Status-Completed%20%26%20Verified-brightgreen)](#)

---

## 📌 Executive Summary
This repository documents the end-to-end implementation of an enterprise-ready, fault-tolerant, and auto-scaling multi-tier web infrastructure on Amazon Web Services (AWS). 

The workload is distributed across multiple Availability Zones with a shared, persistent POSIX storage layer backed by **Amazon EFS**, ensuring high availability, continuous data consistency, zero single points of failure, and seamless automated recovery.

---

## 🏗️ High-Level Architecture

The architecture follows the **AWS Well-Architected Framework** principles for Reliability, Security, and Performance Efficiency:

1. **Networking Layer (VPC):**
   - Custom Multi-AZ VPC spanning `us-east-1a` and `us-east-1b`.
   - Dedicated Public Subnets (hosting the ALB and NAT Gateway) and isolated Private Subnets (hosting compute workloads and EFS Mount Targets).
   - DNS hostnames and internal DNS resolution enabled for automated service discovery.

2. **Compute & Auto Scaling:**
   - Stateless compute instances running **Amazon Linux 2023** managed by an **Auto Scaling Group (ASG)**.
   - Configured via EC2 Launch Templates executing custom bootstrap automation (`scripts/setup-ec2.sh`).

3. **Traffic Distribution (ALB):**
   - Internet-facing **Application Load Balancer (ALB)** performing HTTP Layer-7 Health Checks (`/`) across target instances.

4. **Shared Storage (Amazon EFS):**
   - Multi-AZ Amazon Elastic File System mounted across EC2 instances simultaneously via NFS (port 2049) over TLS.
   - Centralized shared web root (`/mnt/efs` symlinked to `/var/www/html`) eliminating web content drift across dynamic instances.

---

## 🔒 Security Architecture (Least Privilege)

| Component | Inbound Traffic | Source / Reference |
| :--- | :--- | :--- |
| **ALB Security Group** | HTTP (80) | `0.0.0.0/0` (Public Ingress) |
| **EC2 Web Instances SG** | HTTP (80) | Restricted exclusively to `ALB-SG` |
| **EFS Mount Target SG** | NFS (2049) | Restricted exclusively to `Web-Instances-SG` |

---

## ⚙️ Automated Bootstrapping & Scripting
All EC2 instances are dynamically initialized using the launch script located at:
📁 [`scripts/setup-ec2.sh`](scripts/setup-ec2.sh)

The script handles:
- Package manager updates (`dnf`).
- Installation of Apache HTTP server (`httpd`) and Amazon EFS utilities (`amazon-efs-utils`).
- Automated mounting of the shared EFS filesystem using TLS encryption.
- Symbolic linking of `/mnt/efs` to `/var/www/html` to serve shared dynamic content.

---

## 🧪 Verification & Resilience Testing

- **Storage Synchronization:** Verified that files written by any node are instantaneously reflected across all instances in all Availability Zones.
- **Failover & Self-Healing:** Manually terminated running EC2 instances; the Auto Scaling Group immediately detected the capacity drop, triggered instance replacement, executed the bootstrap script, mounted the EFS drive, and returned the target group to `Healthy` state without human intervention.
- **DNS Verification:** Successfully served traffic via Load Balancer DNS returning:
  `Hello from EFS Shared Storage!`

---

## 🛠️ Tech Stack & Skills
- **Cloud:** AWS (VPC, EC2, ASG, ALB, EFS, NAT Gateway, Internet Gateway, IAM, CloudWatch)
- **OS & Web:** Amazon Linux 2023, Apache (`httpd`)
- **Protocols:** HTTP, NFSv4, TLS
- **Automation:** Bash Scripting, Launch Templates
