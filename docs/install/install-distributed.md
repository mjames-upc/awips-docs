---
layout: default
type: guide
shortname: Docs
title: Distributed EDEX Install
---

# Two-Server Install (LDM and EDEX)

## ldm server (10.0.0.4)

	Filesystem                                  Size  Used Avail Use% Mounted on
	/dev/sda1                                    30G  7.4G   23G  25% /
	/dev/sdb1                                    14G   41M   13G   1% /mnt/resource
	//edex7203.file.core.windows.net/datastore  100G   31G   70G  31% /awips2/data_store

A small server to run the LDM, write data files to `/awips2/data_store`, and send messages to **Qpid** via **edexBridge**.

To install:

	yum groupinstall awips2-ldm-server

Then edit the file `/awips2/ldm/etc/ldmd.conf` to define the **edexBridge** server nane:

	EXEC    "edexBridge -s 10.0.0.5"

And then to run (as root or user awips):

	ldmadmin start

## edex server (10.0.0.5)

	Filesystem                                  Size  Used Avail Use% Mounted on
	/dev/sda1                                   512G   20G  493G   4% /
	/dev/sdb1                                    63G   53M   60G   1% /mnt/resource
	//edex7203.file.core.windows.net/datastore  100G   31G   70G  31% /awips2/data_store

Our EDEX server has port 5672 open in iptables to accept Qpid messages from 10.0.0.4.  The standard EDEX server install works here, only we will start everything *but* the LDM.

	yum groupinstall awips2-server

and then to start all base services (no LDM)

	edex start base


# Microsoft Azure File Storage

To deploy EDEX on a Microsoft Azure virtual machine, it is recommended to create an **OS Disk** of at least 512GB:

1. Create a new virtual machine (CentOS 7)
2. Select the new vm, then select **Disks**, and modify the attached **OS Disk** to be 512GB (vm must be stopped for this).
3. Log in to the vm as root, and follow the guide [Step by Step: how to resize a Linux VM OS disk in Azure](https://blogs.msdn.microsoft.com/cloud_solution_architect/2016/05/24/step-by-step-how-to-resize-a-linux-vm-os-disk-in-azure-arm/) (with one caveat below...)
4. Use **xfs_growfs** for XFS ([CentOS 7](http://ask.xmodulo.com/expand-xfs-file-system.html)) rather than **resize2fs** for (EXT2/EXT3/EXT4)
5. After you reboot the machine:
	
	 	xfs_growfs /dev/sda1

	check that the OS disk mounts with the correct partition size:

		df -h

> Note: On Azure VMs, `/mnt/resource` is temporary storage and its contents will be deleted on reboot.

