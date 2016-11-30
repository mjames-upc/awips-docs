---
title: Download and Install CAVE
layout: default
---

[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>Mac OS X</paper-button>](http://www.unidata.ucar.edu/downloads/awips2/awips2-cave.dmg)[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>64-bit Linux</paper-button>](http://www.unidata.ucar.edu/software/awips2/installCAVE.sh)[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>32-bit Windows</paper-button>](http://www.unidata.ucar.edu/downloads/awips2/awips-cave.msi)[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>64-bit Windows</paper-button>](http://www.unidata.ucar.edu/downloads/awips2/awips-cave.amd64.msi)

<br>

# OS X client

Download [awips2-cave.dmg](http://www.unidata.ucar.edu/downloads/awips2/awips2-cave.dmg) (263 MB), click to open and drag to your Applications folder.  The application will write to a local data cache directory `~/Library/CAVE`.

<br>

# Windows client

32-bit [awips-cave.msi](http://www.unidata.ucar.edu/downloads/awips2/awips-cave.msi)

64-bit [awips-cave.amd64.msi](http://www.unidata.ucar.edu/downloads/awips2/awips-cave.amd64.msi)

<br>

# Linux client (RedHat/CentOS 6 and 7)

Download and run the script [installCAVE.sh](http://www.unidata.ucar.edu/software/awips2/installCAVE.sh).

    wget http://www.unidata.ucar.edu/software/awips2/installCAVE.sh
    chmod 755 ./installCAVE.sh
    ./installCAVE.sh

This will install to `/awips2/cave` and `/awips2/alertviz` (as well as awips2 system directories like `/awips2/java` and `/awips2/python`).


## Requirements

* OpenGL 2.0
* [Latest NVIDIA driver](http://www.nvidia.com/Download/index.aspx?lang=en-us) for your graphics card.
* 1.5GB disk space (you should be prepared for more with caching datasets in `~/caveData`)
* All package dependencies should be resolved by yum.  Packages such as libXp, libXt, and openmotif will be picked up and installed along with CAVE. 

## How to run CAVE

    /awips2/cave/cave.sh

> AWIPS was originally built for 32-bit Red Hat 5 (which is what the old AWIPS I system runs on).  As of 2016, 64-bit RHEL and CentOS 6 are supported, and Fedora Linux 9-12 should work as well.   **Unsupported distros** include CentOS 7, Ubuntu, Debian, and pretty much everthing else.

# AWIPS Data in the Cloud

Unidata and Microsoft have partnered to offer a EDEX data server in the Azure cloud, open to the Unidata university community and the public.  Select the server in the Connectivity Preferences dialog, or enter **`edex-cloud.unidata.ucar.edu`** (without adding http:// before, or :9581/services after).

![EDEX in the cloud](../images/boEbFSf28t.gif)


# Troubleshooting

## ~/caveData
You can always reset CAVE by manually removing the `~caveData` directory (on OS X remove `~/Library/CAVE`.  Then run `/awips2/cave/cave.sh` again and you will be prompted to connect to an EDEX server again.  Your local files have been removed, but if user and workstation-specific files exist on the EDEX server (meaning you are re-connecting to one you have used before), the remote files will sync again to `~/caveData` or `~/Library/CAVE` (custom colormaps, bundles, etc.). So even if you delete your local sync, you can retrieve any saved bundles from EDEX just by connecting again and selecting the files from the **File > Import** menu.

## No Images Displayed

If you are able to load wire-frame contours but not images, [update your video driver](http://www.nvidia.com/Download/index.aspx?lang=en-us). 
