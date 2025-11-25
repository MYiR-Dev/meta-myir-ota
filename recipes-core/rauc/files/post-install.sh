#!/usr/bin/env python3

"""
Configure mount point depending on boot type

Copyright (C)  2019. STMicroelectronics

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
     http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import ctypes
import ctypes.util
import fileinput
import os
import subprocess
import shutil
import sys

usage = ("Post script to be run :",
         "- after installing the images",
         "- before reboot")

part_prefix = "/dev/disk/by-partlabel/"
mount_partition_file="/sbin/mount-partitions.sh"
temp_mount_dir = "/tmp"
rootfs_dico = {"rootfs" : "A", "rootfs-b" : "B"}
get_next_boot_slot =  {"A" : "B", "B" : "A"}

# userfs is not managed by A/B mechanism
part_dico = {"boot"  : {"A" : "bootfs", "B" : "bootfs-b"},
             "vendorfs": {"A" : "vendorfs", "B" : "vendorfs-b"},
             "rootfs"  : {"A" : "rootfs", "B" : "rootfs-b"}}

#rootfs-b PARTUUID is filled in get_rootfsb_uuid() function
uuid_dico = {"rootfs"  : {"A" : "e91c4e10-16e6-4c0e-bd0e-77becf4a3582", "B" : "unknown"}}

boot_part_num_dico = {"A" : 0, "B" : 1}

def display_usage():
    print("\n".join(usage))
    exit(0)


def get_boot_slot():
    """
    Return boot slot
    """
    with open("/proc/cmdline", "r") as cmdline:
        for line in cmdline:
            cmdline_param = line.split()
            for param in cmdline_param:
                if "rauc.slot=" in param:
                    return param.split("=")[1]
    return None

def mkdir(name):
    if not os.path.exists(name):
        try:
            os.mkdir(name)
        except OSError:
            print ("Creation of %s the directory failed" % name)

def rmdir(name):
    if os.path.exists(name):
        try:
            os.rmdir(name)
        except OSError:
            print ("Deletion of %s the directory failed" % name)

libc = ctypes.CDLL(ctypes.util.find_library('c'), use_errno=True)
def mount(source, target, fs):
    ret = libc.mount(source.encode(), target.encode(), fs.encode(), 0, None)
    if ret < 0:
        errno = ctypes.get_errno()
        #raise OSError(errno, "Error mounting {} ({}) on {}: {}".format(source, fs, target, os.strerror(errno)))
        print("Error mounting %s (%s) on %s: %s" % (source, fs, target, os.strerror(errno)))

def umount(target):
    print("umount to %s" % target)
    ret = libc.umount(target.encode(), None)
    if ret < 0:
        errno = ctypes.get_errno()
        #raise OSError(errno, "Error mounting {} ({}) on {}: {}".format(source, fs, target, os.strerror(errno)))
        print("Error umounting %s : %s" % (target, os.strerror(errno)))


def get_rootfsb_uuid():
    p = subprocess.Popen(["blkid"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, err = p.communicate()
    lines = output.splitlines()
    for line in lines:
         if 'rootfs-b' in str(line):
             for param in line.split():
                if 'PARTUUID=' in str(param):
                    uuid = str(param).split("=")[1].split('"')[1::2][0]
                    print("rootfs-b PARTUUID updated: %s" % uuid)
                    uuid_dico["rootfs"]["B"]=uuid


current_boot_slot = get_boot_slot()
next_boot_slot = get_next_boot_slot[current_boot_slot]

print ("current_boot_slot=%s" % current_boot_slot)

get_rootfsb_uuid()

#update rootfs mount point in boot partition
dirName = "%s/boot_%s" % (temp_mount_dir, next_boot_slot)
mkdir(dirName)
mount('%s%s' % (part_prefix, part_dico["boot"][next_boot_slot]), dirName, 'ext4')

# "A" is the default configuration in build
for root, dirs, files in os.walk("%s/" % dirName):
    for file in files:
        if file.endswith("extlinux.conf"):
            print("Updating: %s" % os.path.join(root, file))
            with fileinput.FileInput("%s" % os.path.join(root, file), inplace=True, backup='.bak') as file:
                for line in file:
                    x = line.replace("root=PARTUUID=%s" % uuid_dico["rootfs"]["A"], "root=PARTUUID=%s" % (uuid_dico["rootfs"][next_boot_slot]))
                    x = x.replace("rauc.slot=A", "rauc.slot=%s" % next_boot_slot)
                    print(x, end='')

umount(dirName)
rmdir(dirName)


#update vendorfs and boot mount points in rootfs partition
dirName = "%s/rootfs_%s" % (temp_mount_dir, next_boot_slot)
mkdir(dirName)
mount('%s%s' % (part_prefix, part_dico["rootfs"][next_boot_slot]), dirName, 'ext4')

with fileinput.FileInput("%s/%s" % (dirName, mount_partition_file), inplace=True, backup='.bak') as file:
    for line in file:
        x = line.replace("%s,/boot" % part_dico["boot"]["A"], "%s,/boot" % part_dico["boot"][next_boot_slot])
        x = x.replace("%s,/vendor" % part_dico["vendorfs"]["A"], "%s,/vendor" % part_dico["vendorfs"][next_boot_slot])
        print(x, end='')

umount(dirName)
rmdir(dirName)

# Update metadata partition to switch to the next boot partition and configure next boot partition in trial state
# bootcount is already initialized on previous non trial boot
subprocess.Popen(["/usr/lib/fwu/update_metadata.sh", "%d" % boot_part_num_dico[next_boot_slot], "%d" % boot_part_num_dico[current_boot_slot], "refuse"])

