---
layout: default
title: EDEX Start and Stop
---

# Quick Start

(as root)

* `edex start`
* `edex log ldm` - watch for live incoming data
* `edex log`  - watch for active data decoding messages


AWIPS EDEX services are managed by the `edex` program

    > edex
    
    [edex status]
     postgres    :: not running
     pypies      :: not running
     qpid        :: not running
     EDEXingest  :: not running
     EDEXgrib    :: not running
     EDEXrequest :: not running
     ldmadmin    :: not running

     edex (status|start|stop|setup|log|purge|users)

The list of available commands is shown at the botton of the command output ([edex start](#edex-start), [edex stop](#edex-stop), [edex setup](#edex-setup), [edex log](#edex-log), [edex purge](#edex-purge), [edex users](#edex-users)).

# edex start

    edex start
    
    Starting EDEX PostgreSQL:                                  [  OK  ]
    Starting httpd:                                            [  OK  ]
    Starting QPID                                              [  OK  ]
    Starting EDEX Camel (request): 
    Starting EDEX Camel (ingest): 
    Starting EDEX Camel (ingestGrib): 
    Starting AWIPS II LDM:The product-queue is OK.
    ...

# edex stop

    edex stop

    Stopping EDEX Camel (request): 
    Stopping EDEX Camel (ingest): 
    Stopping EDEX Camel (ingestGrib): 
    Stopping QPID                                              [  OK  ]
    Stopping httpd:                                            [  OK  ]
    Stopping EDEX PostgreSQL:                                  [  OK  ]
    Stopping AWIPS II LDM:Stopping the LDM server...
    ...
    
# edex setup

    edex setup
    
    [edex] EDEX IP and Hostname Setup
     Checking /awips2/data/pg_hba.conf [OK]
     Checking /awips2/edex/bin/setup.env [OK]
    
    [edit] Hostname edex.unidata.ucar.edu added to /awips2/ldm/etc/ldmd.conf
    [done]

This command configures and/or confirms that the EDEX hostname and IP address definitions exist (`edex setup` is run by `edex start`).

> If your EDEX server is running but you see the message "Connectivity Error: Unable to validate localization preferences" in CAVE, it may mean that the domain name defined in `/awips2/edex/bin/setup.env` can not be resolved from *outside* the server.  Some machines have different **internally-resolved** and **externally-resolved** domain names (cloud-based especially). The name defined in `setup.env` must be **externally-resolvable**.

# edex log

    edex log
    
    [edex] EDEX Log Viewer

     :: No log specified - Defaulting to ingest log
     :: Viewing /awips2/edex/logs/edex-ingest-20151209.log. Press CTRL+C to exit
    
    INFO  2015-12-09 18:34:42,825 [Ingest.binlightning-1] Ingest: EDEX: Ingest - binlightning:: /awips2/data_store/entlightning/20151209/18/SFPA42_KWBC_091833_38031177.2015120918 processed in: 0.0050 (sec) Latency: 0.0550 (sec)
    Time spent in persist: 68
    INFO  2015-12-09 18:34:45,951 [Ingest.obs-1] Ingest: EDEX: Ingest - obs:: /awips2/data_store/metar/20151209/18/SAIN31_VABB_091830_131392869.2015120918 processed in: 0.0810 (sec) Latency: 0.1800 (sec)\

More edex logs...

    edex log grib
    edex log request
    edex log ldm
    edex log radar
    edex log satellite
    edex log text

# edex users

To see a list of clients connecting to your EDEX server, use the `edex users [YYYYMMDD]` command, where `YYYYMMDD` is the optional date string.

    edex users
    
     -- EDEX Users 20160826 --
    user@101.253.20.225
    user@192.168.1.67
    awips@0.0.0.0
    awips@sdsmt.edu
    ...

# edex purge
to view any stuck purge jobs in PortgreSQL (a rare but serious problem if your disk fills up).  The solution to this is to run `edex purge reset`.

# `/etc/init.d` scripts

There are four EDEX services which run on boot:

    service postgres start
    service httpd-pypies start
    service qpidd start
    service edex_camel start
     

There is also an LDM init script called `edex_ldm` which does **not run at boot** (to prevent filling up disk space without EDEX processing or scouring):

    service edex_ldm start

The service config files are located in `/etc/init.d/` and can be edited by **root**:


    ls -la /etc/init.d/ |grep -e edex -e pypies -e qpid

    -rwxr--r--   1 root  root     6693 Nov  7 17:53 edex_camel
    -rwxr-xr-x   1 root  root     1422 Oct 29 15:28 edex_ldm
    -rwxr--r--   1 root  root     2416 Sep  7 15:48 edex_postgres
    -rwxr-xr-x   1 root  root     5510 Aug 26 13:05 httpd-pypies
    -rwxr-xr-x   1 root  root     3450 Aug 26 13:04 qpidd


