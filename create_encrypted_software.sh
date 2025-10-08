#!/bin/bash

SOFTWARE_DIR="$1"      # (ex: /path/to/software)
CONTAINER_SIZE="$2"    # (ex: 1G, 500M)
CONTAINER_PATH="/opt/encrypted_software.luks"
KEY_FILE="/root/.luks-keys/software.key"

if [ -z "$SOFTWARE_DIR" ] || [ -z "$CONTAINER_SIZE" ]; then
    echo "Usage: $0 <SOFTWARE DIR> <CONTAINER SIZE>"
    echo "Example: $0 /path/to/software 1G"
    exit 1
fi

# Key file generation
sudo mkdir -p /root/.luks-keys
sudo dd if=/dev/urandom of="$KEY_FILE" bs=32 count=1
sudo chmod 600 "$KEY_FILE"

# Encrypted container creation
sudo fallocate -l "$CONTAINER_SIZE" "$CONTAINER_PATH"
sudo cryptsetup luksFormat "$CONTAINER_PATH" "$KEY_FILE"

# Open and format the container
sudo cryptsetup luksOpen "$CONTAINER_PATH" encrypted-software --key-file="$KEY_FILE"
sudo mkfs.ext4 /dev/mapper/encrypted-software

# Temporarily mount and copy the software
sudo mkdir -p /tmp/mount-temp
sudo mount /dev/mapper/encrypted-software /tmp/mount-temp
sudo cp -r "$SOFTWARE_DIR"/* /tmp/mount-temp/

# Automatically delete the original directory
sudo rm -rf "$SOFTWARE_DIR"

# Cleanup
sudo umount /tmp/mount-temp
sudo cryptsetup luksClose encrypted-software
sudo rmdir /tmp/mount-temp

echo "Encryption complete: $CONTAINER_PATH"
echo "Key file: $KEY_FILE"
