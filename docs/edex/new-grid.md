---
layout: default
type: guide
shortname: Docs
title: Add a New Grid to EDEX
---

The process of adding a grid to AWIPS II is not trivial.   A geospatial file must exist on the EDEX server which defines the projection and navigation of the new grid, and a reference point must exist in the matching grid definition file (such as **gribModels_NCEP-7.xml**).  This guide will walk you through an example using a regional WRF floater produced 4 times daily at Unidata.  

Grib data is disseminated in two versions, simple referred to as Grib 1 and Grib 2.  The specifications for each grib version can be found on the NCEP website at the following URLs:

Grib 1:   [http://www.nco.ncep.noaa.gov/pmb/docs/on388/](http://www.nco.ncep.noaa.gov/pmb/docs/on388/)

Grib 2:   [http://www.nco.ncep.noaa.gov/pmb/docs/grib2/grib2_doc.shtml](http://www.nco.ncep.noaa.gov/pmb/docs/grib2/grib2_doc.shtml)

There are five pieces of information that must exist to have grib data recognized in AWIPS II:

1. Parameter tables for the center/subcenter. 

2. A parameter information file.

3. An entry in a grib.xml distribution file.

4. A file containing geospatial information for the grib data must be in place before EDEX starts.

5. An entry in one of the various gribModels xml files.

For most models (CONUS NCEP generated models), 1 and 2 will already exist.  3 is satisfied by our ".*grib.*" regular expression in `grib.xml`.  4 and 5 must be added if they do not exist.

If EDEX can not determine the grid information from files 4 and 5, it will still decode and store data into HDF5 and metadata, using the default label `GribModel:7:0:98`.  Steps have been taken to eliminate as many unknown models as possible; however, if a site is bringing in a locally run model it’s likely that some configuration will have to be completed for the model to store properly.

## EXERCISE - Adding a New Grid to EDEX

Download an example grib1 file with wget from the following location:

    wget www.unidata.ucar.edu/staff/mjames/14102318_nmm_d01.GrbF00600

Remember that the data distribution file (`/awips2/edex/data/utility/edex_static/base/distribution/grib.xml`) will match filenames against the regular expression "**.*grib.***", so we need to append a .grib file extension to our WRF grib1 file.

     mv 14102318_nmm_d01.GrbF00600 14102318_nmm_d01.GrbF00600.grib

Copy the file to the manual ingest point `/awips2/edex/data/manual/`

    cp 14102318_nmm_d01.GrbF00600.grib /awips2/edex/data/manual/

Check that the file has been picked up from manual ingest:

    ls -al /awips2/edex/data/manual/
    total 8
    drwxrwxr-x  2 awips fxalpha 4096 Oct 26 08:34 .
    drwxr-xr-x 11 awips fxalpha 4096 Oct 26 08:28 ..

Check that the file has been copied to the raw data store manual directory:

    ls -la /data_store/manual/
    
    total 20
    drwxrwxrwx   5 awips fxalpha 4096 Oct 26 08:31 .
    drwxrwxr-x. 22 awips fxalpha 4096 Oct 23 14:07 ..
    drwxrwxrwx   3 awips fxalpha 4096 Oct 26 08:31 grib
    drwxrwxrwx   4 awips fxalpha 4096 Oct 25 18:08 mcidas
    drwxrwxrwx   4 awips fxalpha 4096 Oct 25 18:06 satellite

    ls -la /data_store/manual/grib/20141026/14/
    total 27180
    drwxrwxrwx 2 awips fxalpha     4096 Oct 26 08:31 .
    drwxrwxrwx 3 awips fxalpha     4096 Oct 26 08:31 ..
    -rw-rw-rw- 1 awips fxalpha 27820168 Oct 26 08:31 14102318_nmm_d01.GrbF00600.grib

Check the most recent log files in `/awips2/edex/logs/`

    ls -latr /awips2/edex/logs/

Grep for part of the filename (`14102318_nmm_d01`) in the `edex-ingestGrib-yyyymmdd.log` file:

    grep 14102318_nmm_d01 edex-ingestGrib-20141026.log
    INFO  2014-10-26 14:31:51,571 [Ingest.GribDecode-6] Ingest: EDEX: Ingest - grib1:: /awips2/data_store/manual/grib/20141026/14/14102318_nmm_d01.GrbF00600.grib processed in: 0.1200 (sec) Latency: 21.8080 (sec)
    INFO  2014-10-26 14:31:51,576 [Ingest.GribDecode-1] Ingest: EDEX: Ingest - grib1:: /awips2/data_store/manual/grib/20141026/14/14102318_nmm_d01.GrbF00600.grib processed in: 0.1180 (sec) Latency: 21.8140 (sec)
    INFO  2014-10-26 14:31:51,598 [Ingest.GribDecode-7] Ingest: EDEX: Ingest - grib1:: /awips2/data_store/manual/grib/20141026/14/14102318_nmm_d01.GrbF00600.grib processed in: 0.4230 (sec) Latency: 21.8360 (sec)
    INFO  2014-10-26 14:31:51,676 [Ingest.GribDecode-4] Ingest: EDEX: Ingest - grib1:: /awips2/data_store/manual/grib/20141026/14/14102318_nmm_d01.GrbF00600.grib processed in: 0.2240 (sec) Latency: 21.9140 (sec)
    
    ...

Count the number of decoding notifications in the log file:

    grep 14102318_nmm_d01 edex-ingestGrib-20141026.log | wc -l
    799

At this point, we have confirmed that EDEX grib ingest works correctly for this file, and that the entire record was decoded.  But how to be sure?  With the NCEP utility wgrib, which provides a product inventory of grib1 messages (wgrib2 is the equivalent for grib2 messages).

Run wgrib on the grib1 message to dump the contents to your screen:

    ./wgrib 14102318_nmm_d01.GrbF00600.grib
    ...
    790:27472390:d=14102318:HPBL:kpds5=221:kpds6=1:kpds7=0:TR=0:P1=6:P2=0:TimeU=1:sfc:6hr fcst:NAve=0
    791:27537224:d=14102318:CAPE:kpds5=157:kpds6=116:kpds7=23040:TR=0:P1=6:P2=0:TimeU=1:90-0 mb above gnd:6hr fcst:NAve=0
    792:27579244:d=14102318:CIN:kpds5=156:kpds6=116:kpds7=23040:TR=0:P1=6:P2=0:TimeU=1:90-0 mb above gnd:6hr fcst:NAve=0
    793:27625066:d=14102318:CAPE:kpds5=157:kpds6=116:kpds7=65280:TR=0:P1=6:P2=0:TimeU=1:255-0 mb above gnd:6hr fcst:NAve=0
    794:27655678:d=14102318:CIN:kpds5=156:kpds6=116:kpds7=65280:TR=0:P1=6:P2=0:TimeU=1:255-0 mb above gnd:6hr fcst:NAve=0
    795:27701500:d=14102318:PLPL:kpds5=141:kpds6=116:kpds7=65280:TR=0:P1=6:P2=0:TimeU=1:255-0 mb above gnd:6hr fcst:NAve=0
    796:27739718:d=14102318:GUST:kpds5=180:kpds6=1:kpds7=0:TR=0:P1=6:P2=0:TimeU=1:sfc:6hr fcst:NAve=0
    797:27773960:d=14102318:LAND:kpds5=81:kpds6=1:kpds7=0:TR=0:P1=6:P2=0:TimeU=1:sfc:6hr fcst:NAve=0
    798:27781758:d=14102318:ICEC:kpds5=91:kpds6=1:kpds7=0:TR=0:P1=6:P2=0:TimeU=1:sfc:6hr fcst:NAve=0
    799:27785754:d=14102318:ALBDO:kpds5=84:kpds6=1:kpds7=0:TR=0:P1=6:P2=0:TimeU=1:sfc:6hr fcst:NAve=0

    ./wgrib 14102318_nmm_d01.GrbF00600.grib | wc -l
    799

799 messages in the grib1 file, 799 "processed in" messages in `edex-ingestGrib` log file.  So far so good.

Now the question becomes, where did this decoded file go to in our EDEX system, and was it matched to a geospatial grid file? (The answer is no).

    psql metadata

    psql (9.2.4)
    Type "help" for help.
    
    metadata=# \dt grid*
               List of relations
     Schema |     Name     | Type  | Owner
    --------+--------------+-------+-------
     awips  | grid         | table | awips
     awips  | grid_info    | table | awips
     awips  | gridcoverage | table | awips
    
To return the most recently added grids:

    metadata=# select * from grid order by inserttime desc;

Note: if you have the LDM and ingestGrib currently processing live data via the IDD, you may have to wade through more recent entries to find the newly-ingested WRF grids.  If you turn off the LDM (or just the NGRID and CONDUIT feeds), the manual ingest file will be the latest in postgres.

To return the most recently added grids which have not matched a geospatial grid file (using the 'GribModel' string in the model name dataURI):
    
    metadata=# select * from grid_info where datasetid like '%GribModel:7:0:89%';
                                    |    8413
     11530106 |        21600 | 2014-10-23 18:00:00 | [FCST_USED]              | 2014-10-24 00:00:00 | 2014-10-24 00:00:00 | 2014-10-26 14:31:51.394 | /grid/2014-10-23_18:00:00.0_(6)/GribModel:7:0:89/null/null/261/BLI/BL/0.0/180.0                                                          |    8401
     11530102 |        21600 | 2014-10-23 18:00:00 | [FCST_USED]              | 2014-10-24 00:00:00 | 2014-10-24 00:00:00 | 2014-10-26 14:31:51.375 | /grid/2014-10-23_18:00:00.0_(6)/GribModel:7:0:89/null/null/261/vW/BL/120.0/150.0                                                         |    8400
     11530101 |        21600 | 2014-10-23 18:00:00 | [FCST_USED]              | 2014-10-24 00:00:00 | 2014-10-24 00:00:00 | 2014-10-26 14:31:51.371 | /grid/2014-10-23_18:00:00.0_(6)/GribModel:7:0:89/null/null/261/CAPE/BL/0.0/180.0

Notice the dataURI of `/grid/2014-10-23_18:00:00.0_(6)/GribModel:7:0:89/null/null/261/CAPE/BL/0.0/180.0`, and speficially the `GribModel:7:0:89/null` portion.  How do we know that this is our WRF grib file decoded?

Check the count!

    metadata=# select count(*) from grid_info where datasetid like '%GribModel:7:0:89%';
     count
    -------
       799
    (1 row)

799 records confirms that this is our WRF grib file.

What does `GribModel:7:0:89` mean? A refresher:

GribModel = default name for grid not found

    7 = center ID (NCEP)
    0 = subcenter ID
    89 = process ID

At this point, EDEX manual ingest and decoding has been confirmed to work, but we need the WRF grib file matched against a geospatial grid file.  Luckily, this bootstrap method provides us with a record of grid projection in the `gridcoverage` table (hint, the entry containing the WRF grid coverage will be the most recently added record)

    metadata=# select * from gridcoverage order by id desc;
    
                dtype             | id  |                                                crs                                                |         dx
    
            |         dy         | firstgridpointcorner |                                                                                          the_geom                                                                                          |       la1        |        lo1        |    name     |  n
    x  |  ny  | spacingunit |  la2   | latin |   lo2    | majoraxis | minoraxis |    lad    |        lov        |      latin1      |      latin2
    ------------------------------+-----+---------------------------------------------------------------------------------------------------+------------
    --------+--------------------+----------------------+------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------+------------------+-------------------+-------------+---
    ---+------+-------------+--------+-------+----------+-----------+-----------+-----------+-------------------+------------------+------------------
     LambertConformalGridCoverage | 261 | PROJCS["Lambert Conformal (SP: 45.36800003051758/45.36800003051758, Origin: -67.0770034790039)", +|   4.2969999
    3133545 |   4.29699993133545 | LowerLeft            | 010300000001000000050000009BA5CAC8A71852C04C83DD3E98214540F9266FBE54F64EC07248FBC38E224540CA1B6
    2A203AD4EC0E64C5DE38E1F4840C1E325036A3E52C03E3F5D417D1E48409BA5CAC8A71852C04C83DD3E98214540 | 42.2830009460449 | -72.3610000610352 |             |  2
    01 |  155 | km          |        |       |          |   6378160 |   6356775 |           | -67.0770034790039 | 45.3680000305176 | 45.3680000305176
                                  |     |   GEOGCS["WGS84(DD)",

The information we need for this grid is such:

    metadata=# select id,nx,ny, dx,dy,majoraxis,minoraxis,la1,lo1,lov,latin1, latin2 from gridcoverage where id=261;
    
     id  | nx  | ny  |        dx        |        dy        | majoraxis | minoraxis |       la1        |        lo1        |        lov        |      lati
    
    n1      |      latin2
    
    -----+-----+-----+------------------+------------------+-----------+-----------+------------------+-------------------+-------------------+----------
    
    --------+------------------
    
     261 | 201 | 155 | 4.29699993133545 | 4.29699993133545 |   6378160 |   6356775 | 42.2830009460449 | -72.3610000610352 | -67.0770034790039 | 45.368000
    
    0305176 | 45.3680000305176
    
    (1 row)
    
    45.3680000305176

###  GEOSPATIAL FILES

1. A file containing geospatial information for the grib data.  Geospatial information files are stored in `/awips2/edex/data/utility/edex_static/base/grib/grids`
        

An easy tip is to grep for existing similar navigation (using majoraxis or minoraxis, or both):

        cd /awips2/edex/data/utility/edex_static/base/grib/grids

        grep 6378160 -A4 -B12 *
        ...
        RUCIcing.xml-<lambertConformalGridCoverage>
        RUCIcing.xml-    <name>305</name>
        RUCIcing.xml-    <description>Regional - CONUS (Lambert Conformal)</description>
        RUCIcing.xml-    <la1>16.322</la1>
        RUCIcing.xml-    <lo1>-125.955</lo1>
        RUCIcing.xml-    <firstGridPointCorner>LowerLeft</firstGridPointCorner>
        RUCIcing.xml-    <nx>151</nx>
        RUCIcing.xml-    <ny>113</ny>
        RUCIcing.xml-    <dx>40.63525</dx>
        RUCIcing.xml-    <dy>40.63525</dy>
        RUCIcing.xml-    <spacingUnit>km</spacingUnit>
        RUCIcing.xml-    <minorAxis>6356775.0</minorAxis>
        RUCIcing.xml:    <majorAxis>6378160.0</majorAxis>
        RUCIcing.xml-    <lov>-95.0</lov>
        RUCIcing.xml-    <latin1>25.0</latin1>
        RUCIcing.xml-    <latin2>25.0</latin2>
        RUCIcing.xml-</lambertConformalGridCoverage>


Copy the RUCIcing.xml template to the new `grids` directory:

        cp RUCIcing.xml wrf.xml

And edit the new wrf.xml file to include the necessary projection information (example provided):

    vi wrf.xml
    
    <lambertConformalGridCoverage>
        <name>201155</name>
        <description>Regional - CONUS (Lambert Conformal)</description>
        <la1>42.2830009460449</la1>
        <lo1>-72.3610000610352</lo1>
        <firstGridPointCorner>LowerLeft</firstGridPointCorner>
        <nx>201</nx>
        <ny>155</ny>
        <dx>4.29699993133545</dx>
        <dy>4.29699993133545</dy>
        <spacingUnit>km</spacingUnit>
        <minorAxis>6356775.0</minorAxis>
        <majorAxis>6378160.0</majorAxis>
        <lov>-67.0770034790039</lov>
        <latin1>45.3680000305176</latin1>
        <latin2>45.3680000305176</latin2>
    </lambertConformalGridCoverage>

### GRID MODEL FILES

2. A grib model xml file with a unique numerical grid identifier.  The contents between the `<grid>` tags must match the contents between the `<name>` tags in the geospatial information file.  Grib model xml files are found in `/awips2/edex/data/utility/edex_static/base/grid/models`.

Notice `<name>201155</name>` defined from the number of grid points (201 x 155) in the previous geospatial file.  This is the name that must be matched in our new file `gribModels_UPC.xml`, which requires an entry in order for this grid to work.  

First we create a site localization `models` directory:

    cd /awips2/edex/data/utility/edex_static/base/grib/models/

    vi gribModels_UPC.xml

The contents of this file should be such: 
    
    <?xml version="1.0" encoding="UTF-8"?>
    <gribModelSet>
        <model>
            <name>WRF</name>
            <center>7</center>
            <subcenter>0</subcenter>
            <grid>201155</grid>
            <process>
                <id>89</id>
            </process>
        </model>
    </gribModelSet>

Recall the known IDs of the grid:

    7 = center ID (NCEP)
    0 = subcenter ID
    89 = process ID

And notice `<grid>201155</grid>` is used to identify the new `wrf.xml` file that we created.

With the new entry in `gribModels_UPC.xml` referencing our new `wrf.xml` geospatial file, we can test WRF ingest once again, but we have to restart the **ingestGrib** JVM to re-read the new files.

As root:

    service edex_camel restart
    Stopping EDEX Camel (request): OK
    Stopping EDEX Camel (ingest): OK
    Stopping EDEX Camel (ingestGrib): OK
    Starting EDEX Camel (request): OK
    Starting EDEX Camel (ingest): OK
    Starting EDEX Camel (ingestGrib): OK

Remember to check `/awips2/edex/logs/` and the "**edex**" command to be sure that no typos result in the JVM crashing on start (usually give the process a minute or two to spin up and check that process IDs are returned with "**edex**").  If you left the LDM on while restarting the JVM, when the JVM comes back live you will see "**processed in**" messages by tailing the log file.

Now we can manually copy the WRF grib1 file over to `/awips2/edex/data/manual/` again (if we set things up correctly we will not get a persistence error by ingesting the same data since it should be matched to "**WRF**" and not default to `GribModel:7:0:89`.

    cp 14102318_nmm_d01.GrbF00600.grib /awips2/edex/data/manual/

    tail -f /awips2/edex/logs/edex-ingestGrib-20141026.log
    
    INFO  2014-10-26 15:17:50,675 [Ingest.GribDecode-6] Ingest: EDEX: Ingest - grib1:: /awips2/data_store/manual/grib/20141026/15/14102318_nmm_d01.GrbF00600.grib processed in: 0.3040 (sec) Latency: 9.3930 (sec)
    INFO  2014-10-26 15:17:50,703 [Ingest.GribDecode-2] Ingest: EDEX: Ingest - grib1:: /awips2/data_store/manual/grib/20141026/15/14102318_nmm_d01.GrbF00600.grib processed in: 0.1350 (sec) Latency: 9.4210 (sec)
    INFO  2014-10-26 15:17:50,725 [Ingest.GribDecode-1] Ingest: EDEX: Ingest - grib1:: /awips2/data_store/manual/grib/20141026/15/14102318_nmm_d01.GrbF00600.grib processed in: 0.3790 (sec) Latency: 9.4430 (sec)

Now we check in postgres again to see if the dataURI includes the "**WRF**" name rather than "**GribModel:7:0:89**"

        psql metadata

        metadata=# select * from grid order by inserttime desc;
            id    | forecasttime |       reftime       |       utilityflags       |      rangeend       |     rangestart      |       inserttime        |
                                                                      datauri                                                                  | info_id
            
            ----------+--------------+---------------------+--------------------------+---------------------+---------------------+-------------------------+----
               ---------------------------------------------------------------------------------------------------------------------------------------+---------
                 11585397 |        21600 | 2014-10-23 18:00:00 | [FCST_USED]              | 2014-10-24 00:00:00 | 2014-10-24 00:00:00 | 2014-10-26 15:34:12.456 | /gr
                id/2014-10-23_18:00:00.0_(6)/WRF/null/null/261/ICEC/SFC/0.0/-999999.0                                                                  |    9215
                 11585395 |        21600 | 2014-10-23 18:00:00 | [FCST_USED]              | 2014-10-24 00:00:00 | 2014-10-24 00:00:00 | 2014-10-26 15:34:12.449 | /gr
                id/2014-10-23_18:00:00.0_(6)/WRF/null/null/261/LAND/SFC/0.0/-999999.0                                                                  |    9213
                 11585396 |        21600 | 2014-10-23 18:00:00 | [FCST_USED]

SUCCESS!

We have now added a new grid to EDEX.  In order to display it in NCP or D2D we need to edit new localization files for either or both perspective.

### Troubleshooting Grib Ingest

If you ingest a piece of data and the parameter appears as unknown in the metadata database, ensure that the correct parameter tables are in place for the center/subcenter.

Make sure the latitude and longitude entries in your coverage specification file match those of your ingested raw grib file. There is a tolerance of +/- 0.1 degree to keep in mind when defining your coverage area.

If some of the information is unknown, using a grib utility application such as *wgrib* and *wgrib2* (not delivered) can be useful in determining the information that must be added to correctly process a new grib file.
