#!/bin/sh
set -eu

N_RUNS="${N_RUNS:-10}"

if mount | grep /tmp | grep tmpfs >/dev/null; then
    ram_disk=/tmp/sqlite_ramdisk
    >&2 echo "/tmp on tmpfs, running experiment from $ram_disk"
    mkdir /tmp/sqlite_ramdisk
else
    ram_disk=/mnt/sqlite_ramdisk
    >&2 echo "We'll use sudo to mount a RAM disk at $ram_disk"
    sudo mkdir /mnt/sqlite_ramdisk
    sudo mount -t tmpfs none /mnt/sqlite_ramdisk
fi

cp app-sqlite-linux-native database.db "$ram_disk"
cd "$ram_disk"

>&2 echo "Setting CPU3 governor to performance"
sudo sh -c "echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

for i in $(seq 1 $N_RUNS); do
    taskset -c 3 ./app-sqlite-linux-native
done

rm app-sqlite-linux-native database.db
cd
if [ "$ram_disk" = "/mnt/sqlite_ramdisk" ]; then
    >&2 echo "Unmounting RAM disk"
    sudo umount "$ram_disk"
fi
>&2 echo "Removing $ram_disk"
sudo rmdir "$ram_disk"
