#!/bin/bash
# -------------------------------------------------------------
# Setup Script for Multi-AZ Web Infrastructure on Amazon Linux 2023
# Tasks: Updates packages, installs Apache & EFS utils, mounts EFS, and sets up web root.
# -------------------------------------------------------------

# 1. Update system packages and install Apache & EFS Utilities
dnf update -y
dnf install -y httpd amazon-efs-utils

# 2. Enable and start Apache service
systemctl start httpd
systemctl enable httpd

# 3. Configure EFS Mount Target
EFS_FS_ID="fs-0cf163741ba7d62e0"
MOUNT_DIR="/mnt/efs"

mkdir -p ${MOUNT_DIR}

# Mount EFS using TLS
mount -t efs -o tls ${EFS_FS_ID}:/ ${MOUNT_DIR}

# 4. Verify mount and deploy web page
if [ $? -eq 0 ]; then
    echo "<h1>Hello from EFS Shared Storage!</h1>" > ${MOUNT_DIR}/index.html
    echo "<p>Served by Private Instance IP: $(hostname -I | awk '{print $1}')</p>" >> ${MOUNT_DIR}/index.html
    rm -rf /var/www/html
    ln -s ${MOUNT_DIR} /var/www/html
else
    echo "<h1>Hello from Web Server (Local Fallback)</h1>" > /var/www/html/index.html
    echo "<p>Instance IP: $(hostname -I | awk '{print $1}')</p>" >> /var/www/html/index.html
fi
