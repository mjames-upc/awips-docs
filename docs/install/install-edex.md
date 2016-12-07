---
layout: default
type: guide
shortname: Docs
title: EDEX Data Server Installation 
---

# <core-icon icon="fa:linux" aria-label="file-download" role="img"></core-icon> EDEX for Linux 

[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>installEDEX.sh</paper-button>](http://www.unidata.ucar.edu/software/awips2/installEDEX.sh) Installs to subdirectories in`/awips2`

## Linux System Requirements

>* **64-bit** CentOS/RHEL 6 or 7
>* **8 CPU** cores (16 recommended) 
>* **16GB** RAM (32+GB recommended for full IDD processing)
>* **500GB** disk space, more if you build a data archive. An **SSD is an especially good idea here**, mounted to `/awips2/edex/data/hdf5`  to contain the decoded data files, or mounted to `/awips2` to contain the entire AWIPS software system.
 
EDEX **can scale to any system**, either by adjusting the incoming data feeds, or the resources allocated to each data type (read more), but when selecting a server, **more is always better**.

**64-bit CentOS/RHEL 6 and 7** are the only supported Linux operating systems. You may have luck with Fedora Core 12 to 14 and Scientific Linux. EDEX is not developed, tested, or supported on Debian, Ubuntu, SUSE, Solaris, OS X, or Windows.

---

# Linux One-Time Setup (as root)

## 1. Create user and group **awips:fxalpha**

`groupadd fxalpha && useradd -G fxalpha awips`

## 2. Configure iptables to allow TCP connections on ports **5672**, **9581** and **9582**

- To open ports to **all connections**
    
    `vi /etc/sysconfig/iptables`
    
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

- To open ports to **specific IP addresses**
    
    `vi /etc/sysconfig/iptables`
    
        *filter
        :INPUT DROP [0:0]
        :FORWARD DROP [0:0]
        :OUTPUT ACCEPT [0:0]
        :EXTERNAL - [0:0]
        :EDEX - [0:0]
        
        -A INPUT -i lo -j ACCEPT
        -A INPUT -p icmp --icmp-type any -j ACCEPT
        -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
        -A INPUT -s 128.117.140.0/24 -j EDEX
        -A INPUT -s 128.117.156.0/24 -j EDEX
        -A INPUT -j EXTERNAL
        -A EXTERNAL -j REJECT
        
        -A EDEX -m state --state NEW -p tcp --dport 22 -j ACCEPT
        -A EDEX -m state --state NEW -p tcp --dport 5672 -j ACCEPT
        -A EDEX -m state --state NEW -p tcp --dport 9581 -j ACCEPT
        -A EDEX -m state --state NEW -p tcp --dport 9582 -j ACCEPT
        -A EDEX -j REJECT
        COMMIT
    
    > In this example, the IP range `128.117.140.0/24` will match all 128.117.140.* addresses, while `128.117.156.0/24` will match 128.117.156.*.
 
## 3. Restart iptables

`service iptables restart`

## 4. Disable SELinux

`vi /etc/sysconfig/selinux`
    
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

> [Read more about selinux at redhat.com](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security-Enhanced_Linux/sect-Security-Enhanced_Linux-Enabling_and_Disabling_SELinux-Disabling_SELinux.html)

## 4. `reboot`

Only required if iptables was updated.

## 5. Data Disks
    
`/awips2` requires 20GB for installed software.

`/awips2/data_store` will contain the last hours' worth of raw data written by the LDM (~20GB).  Scouring of this directory is performed by EDEX to only retain the last hours worth of data (previously with `ldmadmin scour` the minimum was *24 hours*).

`/awips2/edex/data/hdf5` requires 500GB for live data ingest of all IDD feeds. We recommend mounting an **SSD** here, or to the entire `/awips2` filesystem (or both, as shown):
    
        Filesystem      Size  Used Avail Use% Mounted on
        /dev/sda1        30G  2.5G   26G   9% /
        tmpfs            28G     0   28G   0% /dev/shm
        /dev/sdc1       788G   81G  667G  11% /awips2
        /dev/sdb1       788G   41G  708G  10% /awips2/edex/data/hdf5


## 6. Install EDEX

- `wget http://www.unidata.ucar.edu/software/awips2/installEDEX.sh`

- `chmod 755 ./installEDEX.sh`

- `./installEDEX.sh`

What does `installEDEX.sh` do?

>1. Downloads [awips2.repo](http://www.unidata.ucar.edu/software/awips2/doc/awips2.repo) or [el7.repo](http://www.unidata.ucar.edu/software/awips2/doc/el7.repo) to `/etc/yum.repos.d/awips2.repo`
>2. Runs `yum clean all`
>3. Runs `yum groupinstall awips2-server`

## 7. `edex setup`

The command `edex setup` attempts to add the domain name of your server. 

- `/awips2/edex/bin/setup.env` **should contain the fully-qualified domain name**, externally resolved, localhost will not work. 

        export AW_SITE_IDENTIFIER=BOU
        export EDEX_SERVER=edex.westus.cloudapp.azure.com

- `/awips2/ldm/etc/ldmd.conf` contains the upstream server (default *idd.unidata.ucar.edu*, which requires you connect form a .edu domain). This file also contains the **edexBridge** hostname (default *localhost*). 

        EXEC    "pqact -e"
        EXEC    "edexBridge -s localhost"

- `/etc/security/limits.conf` defines the number of user processes and files (this step is automatically performed by `installEDEX.sh`). Without these definitions, Qpid is known to crash during periods of high ingest.
    
        awips soft nproc 65536
        awips soft nofile 65536

To start and stop EDEX

    edex start
    
and

    edex stop

---

# Important Directories

* `/awips2` - Contains all of the installed AWIPS software. 
* `/awips2/edex/logs` - EDEX logs.
* `/awips2/httpd_pypies/var/log/httpd` - httpd-pypies logs.
* `/awips2/data/pg_log` - PostgreSQL logs.
* `/awips2/qpid/log` - Qpid logs.
* `/awips2/edex/data/hdf5` - HDF5 data store. 
* `/awips2/edex/data/utility` - Localization store and configuration files. 
* `/awips2/ldm/etc` - Location of **ldmd.conf** and **pqact.conf**
* `/awips2/ldm/logs` - LDM logs.
* `/awips2/data_store` - Raw data store.
