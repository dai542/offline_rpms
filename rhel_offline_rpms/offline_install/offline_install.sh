#!/bin/bash

if [ "$USER" != root ]; then
    echo "Please run this script as root!"
    exit 1
fi

sed -i 's/^enabled *= *.*/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf
sed -i 's/^enabled *= *.*/enabled=0/g' /etc/yum/pluginconf.d/product-id.conf

# Mount ISO if needed
if [ ! -d "/mnt/offline_packages" ]; then
    mkdir -p "/mnt/offline_packages"
    if [ ! -f ./offline_packages.iso ]; then
        echo "Error: offline_packages.iso not found!"
        exit 1
    fi
    mount -o loop offline_packages.iso "/mnt/offline_packages"
fi

# Configure local repository
mkdir -p /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/ 2>/dev/null
cp "/mnt/offline_packages/local.repo" /etc/yum.repos.d/

# Clean and rebuild cache
dnf clean all
dnf makecache

# First install base tools
echo "Installing base tools..."
rpm -Uvh "/mnt/offline_packages"/rpms/createrepo_c-*.rpm "/mnt/offline_packages"/rpms/yum-utils-*.rpm --nodeps

# Install all packages from package.list
echo "Installing packages from package.list..."
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]] && continue
    
    package=$(echo "$line" | sed -e 's/#.*$//' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    [ -z "$package" ] && continue
    
    if [[ $package == @* ]]; then
        # Install group
        group="${package#@}"
        echo "Installing group: $group"
        dnf groupinstall -y --disablerepo=* --enablerepo=local "$group"
    else
        # Install individual package
        echo "Installing package: $package"
        dnf install -y --disablerepo=* --enablerepo=local "$package"
    fi
done < "/mnt/offline_packages/package.list"

# Restore original repository configuration
mv /etc/yum.repos.d/backup/* /etc/yum.repos.d/ 2>/dev/null
rm -rf /etc/yum.repos.d/backup

# Unmount ISO if we mounted it
mountpoint -q "/mnt/offline_packages" && umount "/mnt/offline_packages"
