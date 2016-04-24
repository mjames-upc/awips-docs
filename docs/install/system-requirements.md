---
title: Unidata AWIPS System Requirements
layout: default
---

# CAVE

* 64-bit CentOS/RHEL 5 or 6 (including the latest 6.7) (or Mac)
* 8GB memory
* 1.5GB disk space (you should be prepared for more with caching datasets in `~/caveData`)
* 2GB video ram and OpenGL 2.0
* [Latest NVIDIA driver](http://www.nvidia.com/Download/index.aspx?lang=en-us) for your graphics card.
* All package dependencies should be resolved by yum.  Packages such as libXp, libXt, and openmotif will be picked up and installed along with CAVE.  

# EDEX


* 64-bit CentOS/RHEL 5 or 6 (including the latest 6.7).
* 4 CPU cores minimum, 8+ recommended (EDEX can scale to any system limitations by reducing the amount of incoming data and/or turning off certain decoders). 
* 8GB memory minimum, 24GB and 32GB recommended to process more IDD data feeds
* 250GB minimum footprint, 400GB with full IDD ingest, more if you plan to build a data archive (100 GB/day for 3 months = 10TB)
* A **Solid State Drive** is recommended if you want to process high volume feeds such as NEXRAD3 and CONDUIT.