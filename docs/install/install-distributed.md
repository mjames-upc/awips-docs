---
layout: default
type: guide
shortname: Docs
title: Distributed EDEX Install
---

# Distributed EDEX in the Azure Cloud (CentOS 7)



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

	yum install iptables-services

	vi /etc/sysconfig/iptables
	
	# sample configuration for iptables service
	# you can edit this manually or use system-config-firewall
	# please do not ask us to add additional ports/services to this default configuration
	*filter
	:INPUT ACCEPT [0:0]
	:FORWARD ACCEPT [0:0]
	:OUTPUT ACCEPT [0:0]
	-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
	-A INPUT -p icmp -j ACCEPT
	-A INPUT -i lo -j ACCEPT
	-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
	-A INPUT -m state --state NEW -m tcp -p tcp --dport 5672 -j ACCEPT
	-A INPUT -m state --state NEW -m tcp -p tcp --dport 9581 -j ACCEPT
	-A INPUT -m state --state NEW -m tcp -p tcp --dport 9582 -j ACCEPT
	-A INPUT -j REJECT --reject-with icmp-host-prohibited
	-A FORWARD -j REJECT --reject-with icmp-host-prohibited
	COMMIT

	service iptables restart

	yum groupinstall awips2-server

and then to start all base services (no LDM)

	edex start base


# Microsoft Azure File Storage

To deploy EDEX on a Microsoft Azure virtual machine, it is recommended to create an **OS Disk** of at least 512GB:

1. Create a new virtual machine (CentOS 7)
2. Select the new vm, then select **Disks**, and modify the attached **OS Disk** to be 512GB or greater (vm must be stopped for this).
3. Start the VM, log in root, and follow the guide [Step by Step: how to resize a Linux VM OS disk in Azure](https://blogs.msdn.microsoft.com/cloud_solution_architect/2016/05/24/step-by-step-how-to-resize-a-linux-vm-os-disk-in-azure-arm/) (with one caveat below...)
	* sudo fdisk /dev/sda
	* type "u" to change the units to sectors.
	* type "p" to list current partition details.
	* type "d" to delete the current partition.
	* type "n" to create a new partition. Select defaults (p for primary partition, 1 for first part).
	* type "w" to write the partition.

4. Reboot the machine.
5. Log in again and type

	 	xfs_growfs /dev/sda1

	We use **xfs_growfs** here for XFS ([CentOS 7](http://ask.xmodulo.com/expand-xfs-file-system.html)) instead of **resize2fs** for EXT2/EXT3/EXT4 (CentOS 6).
	

	check that the OS disk mounts with the new  partition size:

		df -h

> Note: On Azure VMs, `/mnt/resource` is temporary storage and its contents will be deleted on reboot.

# EDEX Azure Linux CentOS 7 Config

