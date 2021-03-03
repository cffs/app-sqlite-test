#!/bin/sh
set -eu

N_RUNS="${N_RUNS:-10}"

# Depending on your system, you might want to change system parameters to
# improve repeatability (e.g. disable turbo boost, fix cpufreq governor)

>&2 echo "Set CPU governor of CPU3 to performance"
sudo sh -c "echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor"
for i in $(seq 1 $N_RUNS); do
    taskset -c 3 \
        qemu-system-x86_64 -cpu host -enable-kvm -m 50M -nodefaults -no-acpi \
        -display none -serial stdio -device isa-debug-exit \
        -kernel build/app-sqlite_kvm-x86_64.dbg -initrd sqlite.cpio || true
done
