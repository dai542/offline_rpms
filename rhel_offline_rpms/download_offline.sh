#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Configuration variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOWNLOAD_DIR="/root/offline_packages"
ISO_NAME="offline_packages.iso"
MOUNT_POINT="/mnt/offline_packages"
LOG_FILE="$DOWNLOAD_DIR/download.log"
MISSING_DEPS_FILE="$DOWNLOAD_DIR/missing_deps.txt"
PACKAGE_LIST="$SCRIPT_DIR/package.list"

# Check if package list file exists
if [ ! -f "$PACKAGE_LIST" ]; then
    echo "Error: package.list not found!"
    exit 1
fi

# First ensure we have the necessary tools on the online node
echo "Checking and installing required tools..."
dnf clean packages;dnf clean all;dnf makecache -y;dnf -y install createrepo_c yum-utils createrepo --nogpgcheck

# Verify tools installation
if ! rpm -q yum-utils &>/dev/null; then
    echo "Error: yum-utils not installed!"
    exit 1
fi

# Check for either createrepo_c or createrepo
if ! (rpm -q createrepo_c &>/dev/null || rpm -q createrepo &>/dev/null); then
    echo "Error: Neither createrepo_c nor createrepo is installed!"
    exit 1
fi

# Create download directory
mkdir -p "$DOWNLOAD_DIR/rpms"
cd "$DOWNLOAD_DIR" || exit 1

# Configure DNF for better performance
echo "Configuring DNF..."
cat > /etc/dnf/dnf.conf << 'EOF'
[main]
gpgcheck=0
install_weak_deps=True
keepcache=1
best=1
max_parallel_downloads=10
fastestmirror=true
EOF

# Disable subscription-manager plugin if exists
if [ -f /etc/yum/pluginconf.d/subscription-manager.conf ]; then
    echo "Disabling subscription-manager..."
    sed -i 's/^enabled *= *.*/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf
    sed -i 's/^enabled *= *.*/enabled=0/g' /etc/yum/pluginconf.d/product-id.conf
fi

# Download base tools and dependencies first
echo "Downloading base tools and dependencies..."
cd "$DOWNLOAD_DIR/rpms"
dnf download --resolve --alldeps \
    createrepo_c yum-utils createrepo \
    glibc glibc-common bash coreutils \
    dnf yum rpm systemd \
    curl wget vim-minimal \
    rpm-build make gcc \
    which file findutils \
    tar gzip bzip2 xz

# Show package information and confirm
echo "First 10 packages to be downloaded:"
head -n 10 "$PACKAGE_LIST"
echo "..."
echo "Total packages: $(grep -v '^#' "$PACKAGE_LIST" | grep -v '^$' | wc -l)"
echo "Please review $PACKAGE_LIST to ensure all package names are correct."
read -p "Continue with download? (y/N) [y]: " confirm
confirm=${confirm:-y}
if [[ $confirm != "y" && $confirm != "Y" ]]; then
    echo "Aborted."
    exit 1
fi

# Process packages from package.list
echo "Starting package download..."
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]] && continue
    
    package=$(echo "$line" | sed -e 's/#.*$//' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    [ -z "$package" ] && continue
    
    echo "Processing: $package"
    if [[ $package == @* ]]; then
        # Handle group packages
        group="${package#@}"
        echo "Downloading group: $group"
        dnf groupinstall --downloadonly --downloaddir="$DOWNLOAD_DIR/rpms" -y "$group" >> "$LOG_FILE" 2>&1
    else
        # Handle individual packages
        if [[ $package == *"*"* ]]; then
            # Handle wildcard packages
            dnf list --available "$package" | awk 'NR>1 {print $1}' | while read -r pkg; do
                echo "Downloading wildcard match: $pkg"
                dnf download --resolve --alldeps --destdir="$DOWNLOAD_DIR/rpms" "$pkg" >> "$LOG_FILE" 2>&1
            done
        else
            dnf download --resolve --alldeps --destdir="$DOWNLOAD_DIR/rpms" "$package" >> "$LOG_FILE" 2>&1
        fi
    fi
done < "$PACKAGE_LIST"

# Optimized dependency check function
check_dependencies() {
    local TEMP_DB="/tmp/rpmdb_temp"
    rm -rf "$TEMP_DB"
    mkdir -p "$TEMP_DB"
    rpm --initdb --dbpath "$TEMP_DB"
    
    echo "Checking all dependencies..."
    find "$DOWNLOAD_DIR/rpms" -name "*.rpm" -type f -exec rpm -i --justdb --nodeps --dbpath "$TEMP_DB" {} \; 2>/dev/null
    
    # One-time check for all missing dependencies
    echo "Analyzing dependencies..."
    local missing_deps=$(find "$DOWNLOAD_DIR/rpms" -name "*.rpm" -type f -exec rpm -qpR {} \; | sort -u | \
        while read -r req; do
            [[ "$req" == rpmlib* ]] && continue
            [[ "$req" == /bin/* ]] && continue
            [[ "$req" == /usr/bin/* ]] && continue
            [[ "$req" == "config("* ]] && continue
            [[ "$req" == "rtld("* ]] && continue
            
            if ! rpm -q --whatprovides "$req" --dbpath "$TEMP_DB" &>/dev/null; then
                echo "$req"
            fi
        done)
    
    if [ -n "$missing_deps" ]; then
        echo "Found missing dependencies. Downloading..."
        echo "$missing_deps" > "$MISSING_DEPS_FILE"
        echo "$missing_deps" | xargs -r dnf download --resolve --alldeps --destdir="$DOWNLOAD_DIR/rpms"
        return 1
    else
        echo "All dependencies are satisfied"
        return 0
    fi
}

# Perform dependency check
echo "Performing dependency check..."
check_dependencies
if [ $? -ne 0 ]; then
    echo "Running final dependency check after downloading missing dependencies..."
    check_dependencies
    if [ $? -ne 0 ]; then
        echo "Warning: Some dependencies could not be resolved."
        read -p "Continue anyway? (y/N) [y]: " continue_anyway
        continue_anyway=${continue_anyway:-y}
        if [[ $continue_anyway != "y" && $continue_anyway != "Y" ]]; then
            echo "Operation cancelled"
            exit 1
        fi
    fi
fi

# Create repository
echo "Creating local repository..."
createrepo_c "$DOWNLOAD_DIR/rpms"

# Create local repository configuration
cat > "$DOWNLOAD_DIR/local.repo" << EOF
[local]
name=Local Repository
baseurl=file://$MOUNT_POINT/rpms
enabled=1
gpgcheck=0
EOF

# Copy original package.list
cp "$PACKAGE_LIST" "$DOWNLOAD_DIR/"

# Create offline installation script
cat > "$DOWNLOAD_DIR/offline_install.sh" << EOF
#!/bin/bash

if [ "\$USER" != root ]; then
    echo "Please run this script as root!"
    exit 1
fi

sed -i 's/^enabled *= *.*/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf
sed -i 's/^enabled *= *.*/enabled=0/g' /etc/yum/pluginconf.d/product-id.conf

# Mount ISO if needed
if [ ! -d "$MOUNT_POINT" ]; then
    mkdir -p "$MOUNT_POINT"
    if [ ! -f ./offline_packages.iso ]; then
        echo "Error: offline_packages.iso not found!"
        exit 1
    fi
    mount -o loop offline_packages.iso "$MOUNT_POINT"
fi

# Configure local repository
mkdir -p /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/ 2>/dev/null
cp "$MOUNT_POINT/local.repo" /etc/yum.repos.d/

# Clean and rebuild cache
dnf clean all
dnf makecache

# First install base tools
echo "Installing base tools..."
rpm -Uvh "$MOUNT_POINT"/rpms/createrepo_c-*.rpm "$MOUNT_POINT"/rpms/yum-utils-*.rpm --nodeps

# Install all packages from package.list
echo "Installing packages from package.list..."
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "\$line" ]] || [[ "\$line" =~ ^[[:space:]]*# ]] && continue
    
    package=\$(echo "\$line" | sed -e 's/#.*$//' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    [ -z "\$package" ] && continue
    
    if [[ \$package == @* ]]; then
        # Install group
        group="\${package#@}"
        echo "Installing group: \$group"
        dnf groupinstall -y --disablerepo=* --enablerepo=local "\$group"
    else
        # Install individual package
        echo "Installing package: \$package"
        dnf install -y --disablerepo=* --enablerepo=local "\$package"
    fi
done < "$MOUNT_POINT/package.list"

# Restore original repository configuration
mv /etc/yum.repos.d/backup/* /etc/yum.repos.d/ 2>/dev/null
rm -rf /etc/yum.repos.d/backup

# Unmount ISO if we mounted it
mountpoint -q "$MOUNT_POINT" && umount "$MOUNT_POINT"
EOF

chmod +x "$DOWNLOAD_DIR/offline_install.sh"

# Create ISO file
echo "Creating ISO file..."
mkisofs -o "$ISO_NAME" -R -J -joliet-long "$DOWNLOAD_DIR" || {
    echo "Error creating ISO file. Trying with alternative options..."
    genisoimage -o "$ISO_NAME" -R -J -joliet-long "$DOWNLOAD_DIR"
}

# Verify ISO file was created
if [ -f "$ISO_NAME" ]; then
    echo "ISO file created successfully"
    echo "ISO size: $(du -h "$ISO_NAME" | cut -f1)"
else
    echo "Error: Failed to create ISO file"
    exit 1
fi

# Print completion message
echo "Package creation completed!"
echo "Generated ISO file: $ISO_NAME"
echo "Download log: $LOG_FILE"
echo "Missing dependencies (if any): $MISSING_DEPS_FILE"
echo
echo "Installation instructions for offline system:"
echo "1. Transfer $ISO_NAME to target server"
echo "2. On target server, execute:"
echo "   bash offline_install.sh"

echo "Done!"