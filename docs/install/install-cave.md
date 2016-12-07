---
title: Download and Install CAVE
layout: default
---

# <core-icon icon="fa:apple" aria-label="file-download" role="img"></core-icon> CAVE for OS X

[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>awips2-cave-16.2.2.dmg</paper-button>](http://www.unidata.ucar.edu/downloads/awips2/awips2-cave-16.2.2.dmg) Saves files to `~/Library/CAVE`.

<br>

---

# <core-icon icon="fa:windows" aria-label="file-download" role="img"></core-icon> CAVE for Windows

[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>awips-cave.amd64.msi</paper-button>](http://www.unidata.ucar.edu/downloads/awips2/awips-cave.amd64.msi)

[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>awips-cave.msi (32-bit)</paper-button>](http://www.unidata.ucar.edu/downloads/awips2/awips-cave.msi) Saves files to `caveData` in the user's home directory. 

<br>

---

# <core-icon icon="fa:linux" aria-label="file-download" role="img"></core-icon> x86_64 Linux (CentOS/RHEL 6 or 7)

[<paper-button raised role="button" tabindex="0"><core-icon icon="file-download" aria-label="file-download" role="img"></core-icon>installCAVE.sh</paper-button>](http://www.unidata.ucar.edu/software/awips2/installCAVE.sh) Installs to `/awips2/cave` and saves user files to `~/caveData`

    chmod 755 ./installCAVE.sh
    ./installCAVE.sh

## Linux Requirements

* 64-bit CentOS/RHEL 6 or 7
* OpenGL 2.0
* 4GB RAM
* [Latest NVIDIA driver](http://www.nvidia.com/Download/index.aspx?lang=en-us) for your graphics card
* 2GB disk space for caching datasets in `~/caveData`

> All package dependencies should be resolved by yum. 

## How to run CAVE

Find CAVE in the GNOME menu **Applications** &gt; **Internet** &gt; **AWIPS CAVE**

Or from the command line, simply type `cave`

# AWIPS Data in the Cloud

Unidata and Microsoft have partnered to offer a EDEX data server in the Azure cloud, open to the Unidata university community and the public.  Select the server in the Connectivity Preferences dialog, or enter **`edex-cloud.unidata.ucar.edu`** (without adding http:// before, or :9581/services after).

![EDEX in the cloud](../images/boEbFSf28t.gif)


# Troubleshooting

## Localization Preferences Error

You can reset CAVE by removing the `~/caveData` directory (on OS X `~/Library/CAVE`) and then run `cave` again to connect to an EDEX server.  Your local files have been removed, but if you are re-connecting to an EDEX server you have used before, the remote files will sync again to your local `~/caveData` (bundles, colormaps, etc.). 

## No Images Displayed

If you are able to load wire-frame contours but not images, [update your video driver](http://www.nvidia.com/Download/index.aspx?lang=en-us). 
