---
layout: default
type: guide
shortname: Docs
title: EDEX Install and Config 
---

[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>64-bit Linux</paper-button>](http://www.unidata.ucar.edu/software/awips2/installEDEX.sh)

> **EDEX can only be installed on CentOS/RHEL 6 or 7**

---

# System Requirements

* **64-bit CentOS/RHEL 6 or 7**
* **8 CPU** cores (16 recommended) 
* **16GB** RAM (32+GB recommended for full IDD processing)
* **500GB** disk space, more if you plan to build a data archive.
* An **SSD** mounted to `/awips2` contain the entire software system and data files.
 
>## Notes
> * EDEX can scale to any system by reducing the volume of incoming data and/or turning off certain decoders (for example, with 4 core
> * As of AWIPS 16.2.2, scouring of `/awips2/data_store` is performed at 30 minutes past every hour, and the default retention rate is


# Linux One-Time Setup 

Create user and group **awips:awips**.  IP tables will need to be configured to allow specific TCP connections for EDEX: ports **5672**, **9581** and **9582**.
 
- `groupadd awips && useradd -G awips awips`

-  `mkdir -p /awips2/data_store`

-  `vi /etc/sysconfig/iptables`

        # Firewall configuration written by system-config-firewall
        # Manual customization of this file is not recommended.
        *filter
        :INPUT ACCEPT [0:0]
        :FORWARD ACCEPT [0:0]
        :OUTPUT ACCEPT [0:0]
        -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
        -A INPUT -p icmp -j ACCEPT
        -A INPUT -i lo -j ACCEPT
        -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
        -A INPUT -m state --state NEW -m tcp -p tcp --dport 5672 -j ACCEPT
        -A INPUT -m state --state NEW -m tcp -p tcp --dport 9581 -j ACCEPT
        -A INPUT -m state --state NEW -m tcp -p tcp --dport 9582 -j ACCEPT
        -A INPUT -j REJECT --reject-with icmp-host-prohibited
        -A FORWARD -j REJECT --reject-with icmp-host-prohibited
        COMMIT

- `service iptables restart`

- `vi /etc/sysconfig/selinux`
        
        # This file controls the state of SELinux on the system.
        # SELINUX= can take one of these three values:
        #     enforcing - SELinux security policy is enforced.
        #     permissive - SELinux prints warnings instead of enforcing.
        #     disabled - No SELinux policy is loaded.
        SELINUX=disabled
        # SELINUXTYPE= can take one of these two values:
        #     targeted - Targeted processes are protected,
        #     mls - Multi Level Security protection.
        SELINUXTYPE=targeted

- `reboot`

    Only required if iptables was updated in step 5.

- `df -h`
    
    Make sure you have 15GB of storage on `/` for the `/awips2` software, and then ensure you have 500GB (or more) of fast IO file storage (SSD or NFS) available to mount the directories `/awips2/edex/data/hdf5` and `/awips2/data_store`.
    
    - All of `/awips2` on an SSD
        
        For example:
        
            Filesystem      Size  Used Avail Use% Mounted on
            /dev/sda1        30G  2.5G   26G   9% /
            tmpfs            28G     0   28G   0% /dev/shm
            /dev/sdc1       788G   81G  667G  11% /awips2
            /dev/sdb1       788G   69M  748G   1% /mnt/resource
            
    - `/awips2/edex/data/hdf5` on an SSD
    
---

# EDEX Install

- `wget http://www.unidata.ucar.edu/software/awips2/installEDEX.sh`

- `chmod 755 ./installEDEX.sh`

- `./installEDEX.sh`

This will install to `/awips2/edex`, `/awips2/data` and other directories.

> 64-bit CentOS/RHEL 6 and 7 are the only supported Linux operating systems. You may have luck with Fedora Core 12 to 14 and Scientific Linux. EDEX is not supported on Debian, Ubuntu, SUSE, Solaris, OS X, or Windows.

## What does installEDEX.sh do?

1. Downloads [http://www.unidata.ucar.edu/software/awips2/doc/awips2.repo](http://www.unidata.ucar.edu/software/awips2/doc/awips2.repo) to `/etc/yum.repos.d/awips2.repo`
2. Runs `yum clean all`
3. Runs `yum groupinstall awips2-server`

---

# Final Steps

- `/awips2/edex/bin/setup.env` should contain the **fully-qualified domain name** which can be externally resolved (localhost will not work). The command `edex setup` attempts to add the domain name of your EDEX machine to the file, but you should **always confirm this manually**.

- `/awips2/ldm/etc/ldmd.conf` contains the upstream server (default *idd.unidata.ucar.edu*, which requires you connect form a .edu domain). This file also contains the **edexBridge** hostname (default *localhost*).

- selinux should be **disabled** [(read more about selinux at redhat.com)](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security-Enhanced_Linux/sect-Security-Enhanced_Linux-Enabling_and_Disabling_SELinux-Disabling_SELinux.html)
    
- Security Limits - **/etc/security/limits.conf**
 
    Qpid is known to crash on systems without a high security limit for user processes and files. The file `/etc/security/limits.conf` defines the number of each for the awips user (This is automatically configured by the `installEDEX.sh` script).
    
        awips soft nproc 65536
        awips soft nofile 65536
    
# Important Directories

* **/awips2** - This folder contains all of the installed AWIPS software. 
* **/awips2/edex/data/hdf5** - Contains the HDF5 component of the data store and shared static data and hydro apps. 
* **/awips2/edex/data/utility** - Contains localization store and EDEX configuration files. 
* **/awips2/ldm** - LDM account home directory.
* **/awips2/ldm/etc** - Location of *ldmd.conf* and *pqact.conf*.
* **/awips2/ldm/logs** - Location of LDM logs.
* **/awips2/data_store** - Raw Data Store File System
* **/awips2/GFESuite** - Contains scripts and data relating to inter site coordination (ISC) and service backup.    
