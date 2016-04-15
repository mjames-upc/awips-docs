---
title: Download and Install CAVE
layout: default
---


# OS X client

Download [awips2-cave.dmg](http://www.unidata.ucar.edu/downloads/awips2/awips2-cave.dmg) (263 MB)


# Linux client

Download and run the script [installCAVE.sh](http://www.unidata.ucar.edu/software/awips2/installCAVE.sh).

    wget http://www.unidata.ucar.edu/software/awips2/installCAVE.sh
    chmod 755 ./installCAVE.sh
    ./installCAVE.sh

This will install to `/awips2/cave` and `/awips2/alertviz` (as well as awips2 system directories like `/awips2/java` and `/awips2/python`).

# How to run CAVE

    /awips2/cave/cave.sh

> AWIPS II was originally built for 32-bit Red Hat 5 (which is what the old AWIPS I system runs on).  As of 2016, 64-bit RHEL and CentOS 6 are supported, and Fedora Linux 9-12 should work as well.   **Unsupported distros** include CentOS 7, Ubuntu, Debian, and pretty much everthing else.

# AWIPS II Data in the Cloud

Unidata and Microsoft have partnered to offer a EDEX data server in the Azure cloud, open to the Unidata university community and the public.  Select the server in the Connectivity Preferences dialog, or enter **`edex-cloud.unidata.ucar.edu`** (without adding http:// before, or :9581/services after).

![EDEX in the cloud](../images/boEbFSf28t.gif)


