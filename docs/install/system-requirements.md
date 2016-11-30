---
title: Unidata AWIPS System Requirements
layout: default
---

# CAVE

* **CentOS/RHEL 6 or 7, OS X, Windows**
* **8GB** memory
* **1.5GB** disk space (you should be prepared for more with caching datasets in `~/caveData`)
* **2GB** video ram and OpenGL 2.0
* [**Latest NVIDIA driver**](http://www.nvidia.com/Download/index.aspx?lang=en-us) for your graphics card.

# EDEX

* **64-bit CentOS/RHEL 6** (CentOS/RH 7 not supported yet)
* **8 CPU** cores minimum, **16** recommended. 
* **16GB** RAM minimum, **32GB+** recommended for large servers processing more of the IDD.
* **500GB** minimum footprint, more if you plan to build a data archive
* An **SSD** mounted to `/awips2` contain the entire software system and data files.
 
>## Notes
> * EDEX can scale to any system by reducing the volume of incoming data and/or turning off certain decoders (for example, with 4 cores you will only have 4 parallelized decoders running at any one time, which will not be able to handle CONDUIT and NEXRAD3 feeds).
> * As of AWIPS 16.2.2, scouring of `/awips2/data_store` is performed at 30 minutes past every hour, and the default retention rate is **1 hour**. Previous releases used `ldmadmin scour` which had a minimum retention period of 1 day. 

### EDEX Linux File Systems

* **/awips2** - This folder contains all of the installed AWIPS software. 
* **/awips2/edex/data/hdf5** - Contains the HDF5 component of the data store and shared static data and hydro apps. 
* **/awips2/edex/data/utility** - Contains localization store and EDEX configuration files. 
* **/awips2/ldm** - LDM account home directory.
* **/awips2/ldm/etc** - Location of *ldmd.conf* and *pqact.conf*.
* **/awips2/ldm/logs** - Location of LDM logs.
* **/awips2/data_store** - Raw Data Store File System
* **/awips2/GFESuite** - Contains scripts and data relating to inter site coordination (ISC) and service backup.

