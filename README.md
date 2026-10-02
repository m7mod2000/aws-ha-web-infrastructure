# Highly Available & Scalable Multi-AZ Web Infrastructure on AWS

## 📌 Project Overview
This project demonstrates the design, deployment, and end-to-end verification of an enterprise-grade, highly available, and scalable multi-tier cloud infrastructure built on Amazon Web Services (AWS). 

The architecture hosts stateful web content backed by a distributed file system (**Amazon EFS**) across multiple Availability Zones, ensuring zero single points of failure, automated self-healing, and optimal load distribution.

---

## 🏗️ Architecture & Core Components
- **Virtual Private Cloud (VPC):** Custom VPC spanning 2 Availability Zones (`us-east-1a`, `us-east-1b`) with isolated Public and Private subnets.
- **Routing & Isolation:** 
  - Internet Gateway for public ingress/egress.
  - NAT Gateway to enable outbound internet access (for package installation and patches) for instances residing safely in private subnets.
  - DNS hostnames and resolution activated for internal service discovery.
- **Compute Layer (EC2 & ASG):** Amazon Linux 2023 web instances managed by an Auto Scaling Group across private subnets, configured with Launch Templates.
- **Traffic Management (ALB):** Public Application Load Balancer performing Layer-7 HTTP health checks (`/`), routing traffic dynamically to healthy target instances.
- **Shared Storage (Amazon EFS):** Multi-AZ Amazon Elastic File System providing shared, persistent POSIX storage mounted via NFS (port 2049) to eliminate data drift across stateless compute nodes.
- **Security Groups (Least Privilege):** 
  - ALB Security Group: Inbound HTTP (80) from anywhere.
  - Web Instances Security Group: Inbound HTTP (80) restricted exclusively to the ALB.
  - EFS Security Group: Inbound NFS (2049) restricted exclusively to the Web Instances Security Group.

---

## 🚀 Key Implementation Milestones
1. **Network Infrastructure Setup:** Configured custom CIDR blocks, subnets, route tables, and gateways.
2. **Launch Template & Automated Bootstrapping:** Authored an automated User Data bootstrap script that installs Apache (`httpd`), utilities, and dynamically mounts the shared Amazon EFS filesystem on `/mnt/efs`.
3. **Mount Target Network Tuning:** Resolved internal routing constraints by mapping EFS Mount Targets directly inside the respective private subnets and aligning DNS hostname resolutions.
4. **Resilience & Self-Healing Verification:** 
   - Terminated running EC2 instances manually; verified that the Auto Scaling Group detected the capacity deficit and automatically spawned healthy replacement instances without service interruption.
   - Verified that all replacement instances immediately mounted the EFS shared filesystem and served identical synchronized content (`Hello from EFS Shared Storage!`) via ALB DNS.

---

## 🛠️ Technologies Used
- **Cloud Provider:** Amazon Web Services (AWS)
- **Services:** VPC, EC2, Auto Scaling Groups (ASG), Application Load Balancer (ALB), Amazon EFS, NAT Gateway, Internet Gateway, Security Groups.
- **OS & Software:** Amazon Linux 2023, Apache HTTP Server (`httpd`), `amazon-efs-utils`, Bash Scripting.
-
