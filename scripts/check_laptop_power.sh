#!/bin/sh

# For diagnosing power management on AMD laptop
# Used in combination with poewrtop

echo "===== CPU ====="
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_driver | uniq
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | uniq
cat /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference | uniq

echo "===== GPU ====="
cat /sys/class/drm/card*/device/power_dpm_force_performance_level

echo "===== Platform ====="
cat /sys/firmware/acpi/platform_profile

echo "===== Radio devices ====="
rfkill
