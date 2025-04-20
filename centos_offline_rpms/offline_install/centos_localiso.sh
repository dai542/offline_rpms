#!/bin/bash

# Define ISO path and mount directory
ISO_PATH="/root/CentOS-7-x86_64-Everything-2009.iso"
MOUNT_DIR="/mnt/localiso"

echo "Using ISO file: $ISO_PATH"
echo "Mounting to directory: $MOUNT_DIR"

# Create mount directory
mkdir -p "$MOUNT_DIR"

# Mount ISO if not already mounted
echo "Mounting ISO..."
if mount | grep "$MOUNT_DIR" > /dev/null; then
    echo "$MOUNT_DIR is already mounted. Skipping mount."
else
    mount -o loop "$ISO_PATH" "$MOUNT_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to mount ISO. Please check the path: $ISO_PATH"
        exit 1
    fi
fi

# Backup existing yum repo configuration with timestamp
BACKUP_TIME=$(date +%Y%m%d%H%M)
BACKUP_DIR="/etc/yum.repos.d.bak.$BACKUP_TIME"
echo "Backing up /etc/yum.repos.d to: $BACKUP_DIR"
mv /etc/yum.repos.d "$BACKUP_DIR"
mkdir -p /etc/yum.repos.d

# Create new local ISO yum repo
cat > /etc/yum.repos.d/localiso.repo << EOF
[localios]
name=localios
baseurl=file://$MOUNT_DIR
enabled=1
gpgcheck=0
EOF

# Clean yum cache and rebuild
echo "Cleaning yum cache and rebuilding..."
yum clean all
yum makecache -y

echo "Local YUM repository has been configured successfully."