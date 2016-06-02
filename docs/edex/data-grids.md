---
layout: default
type: guide
shortname: Docs
title: Gridded Data
subtitle: Data Types
---

{% include toc.html %}

# AWIPS HDF5 Gridded Data

Gridded data (forecast models, real-time analysis, MRMS, HFR ocean currents, etc.) are stored in `/awips2/edex/data/hdf5/grid/`


    ls /awips2/edex/data/hdf5/grid/
    AK-GFS-22km  ECMF9          FFG-TUA              Hawaii-NamDNG5              HFR-US_WEST_SOCAL_2KM       MPE-Local-TAR   NCWF          QPE-XNAV-FWR  UKMET39
    AK-NAM-45km  ECMF-Global    FNMOC-FAROP          HFR-EAST_6KM                HFR-US_WEST_WASHINGTON_1KM  MPE-Local-TIR   NOHRSC-SNOW   QPE-XNAV-KRF  UKMET40
    AK-NamDNG5   ECMF-Tropical  fnmocWave            HFR-EAST_PR_6KM             HFR-WEST_6KM                MPE-Mosaic-ALR  PR-GFS-20km   QPE-XNAV-MSR  UKMET41
    AUTOSPE      ESTOFS         gefs                 HFR-US_EAST_DELAWARE_1KM    HPCGuide                    MPE-Mosaic-FWR  PR-NAM        QPE-XNAV-ORN  UKMET42
    CMC          estofsPR       GFS                  HFR-US_EAST_FLORIDA_2KM     HPCqpf                      MPE-Mosaic-MSR  PR-NamDNG5    QPE-XNAV-RHA  UKMET43
    DGEX         ETSS           GFS25                HFR-US_EAST_NORTH_2KM       HPCqpfNDFD                  MPE-Mosaic-ORN  QPE-ALR       QPE-XNAV-SJU  UKMET44
    ECMF1        FFG-ALR        GFS40                HFR-US_EAST_SOUTH_2KM       HRRR                        MPE-Mosaic-RHA  QPE-Auto-TUA  QPE-XNAV-TAR  UKMET-Global
    ECMF10       FFG-FWR        GFS-95km             HFR-US_EAST_VIRGINIA_1KM    LAMP2p5                     MPE-Mosaic-SJU  QPE-FWR       QPE-XNAV-TIR  UKMET-MODEL1
    ECMF11       FFG-KRF        GFS-EPac-40km        HFR-US_HAWAII_1KM           MOSGuide                    MPE-Mosaic-TAR  QPE-KRF       QPE-XNAV-TUA  URMA25
    ECMF12       FFG-MSR        GFSGuide             HFR-US_HAWAII_2KM           MOSGuideExtended            MPE-Mosaic-TIR  QPE-MSR       RAP13         WaveWatch
    ECMF2        FFG-ORN        GFSLAMP5             HFR-US_HAWAII_6KM           MPE-Local-ALR               MRMS_1000       QPE-ORN       RAP40         WaveWatch-AK
    ECMF3        FFG-PTR        GLERL                HFR-US_WEST_500M            MPE-Local-MSR               NAM12           QPE-RFC-PTR   RCM           WaveWatch-ENP
    ECMF4        FFG-RHA        GribModel:58:0:135   HFR-US_WEST_CENCAL_2KM      MPE-Local-ORN               NAM40           QPE-RFC-RSA   RFCqpf        WaveWatch-ENP-Hurr
    ECMF5        FFG-RSA        GribModel:58:0:18    HFR-US_WEST_LOSANGELES_1KM  MPE-Local-RHA               NAM90           QPE-RFC-STR   RTMA          WaveWatch-WNA
    ECMF6        FFG-STR        GribModel:58:0:78    HFR-US_WEST_LOSOSOS_1KM     MPE-Local-RSA               NamDNG          QPE-TIR       RTMA5         WaveWatch-WNA-Hurr
    ECMF7        FFG-TAR        GribModel:9:151:172  HFR-US_WEST_NORTH_2KM       MPE-Local-SJU               NamDNG5         QPE-TUA       UKMET37
    ECMF8        FFG-TIR        GribModel:98:0:146   HFR-US_WEST_SANFRAN_1KM     MPE-Local-STR               NAVGEM          QPE-XNAV-ALR  UKMET38

The directory names correspond to the names used in the Volume Browser, the Models Menu bundles, the Python AWIPS Data Access Framework, and the D2D Product Browser.  For each HDF5 grid file there are corresponsing PostgreSQL and PostGIS metadata records (you can query the tables with `psql metadata` - just be careful and sure of what you're doing).

# Unknown Grids

Folders with names like **GribModel:9:151:172** and **GribModel:98:0:146** are created by the grid decoder when it can not find name and projection information. 

# Ingest grib and grib2 files

Simply drop files ending in "*.grib" or "*.grib2" into `/awips2/edex/data/manual/`

    cp HRRR_CONUS_2p5km_201604291900.grib2 /awips2/edex/data/manual/
    
and watch for **Ingest.GribDecode**

You can ingest entire Grib file archives from a tarball with a single command:

    tar -xvzf ARCHIVE.tar.gz -C /awips2/edex/data/manual/

or copy any inidividual file to `/awips2/edex/data/manual` and watch the appropriate log file (grib, radar, satellite, etc.) for the ingest message.

## Data distribution file

**/awips2/edex/data/utility/edex_static/base/distribution/grib.xml**

    <requestPatterns>
        <!-- Super Set of all possible WMO grib patterns -->
        <regex>^[EHLMOYZ][A-Z]{3}\d{2}</regex>
        <!-- This to match Unidata CONDUIT products w/o standard headers -->
        <regex>.*grib.*</regex>
        <regex>^US058.*</regex>
        <regex>^CMC_reg.*</regex>
    </requestPatterns>

## Important files and directories

|---|---|
| location on disk  | **/awips2/edex/data/hdf5/grid**  |
| definition files  | **/awips2/edex/data/utility/edex_static/base/grib/models**  |
| navigation files  | **/awips2/edex/data/utility/edex_static/base/grib/grids**  |
| grib1 definitions | **/awips2/edex/data/utility/common_static/base/grid** |
| D2D files  | **/awips2/edex/data/utility/edex_static/base/grib/grids**  |
| metadata tables | **grid** |
|                 | **grid_info** |
|                 | **gridcoverage** |

## Default feed types in /awips2/ldm/etc/ldmd.conf




## Default pattern actions in /awips2/ldm/etc/pqact.conf

### GFS 0.5 degree

      CONDUIT ^data/nccf/com/.*gfs.t[0-9][0-9]z.(pgrb2.0p50).*!(grib2)/[^/]*/(SSIGFS|GFS)/#([^/]*)/([0-9]{8})([0-9]{4})(F[0-9]..)/([^/]*)/.*! (......)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/conduit/GFS/\5_\6Z_\7_\8-(seq).\1.grib2
              
### NAM-40km
      CONDUIT ^data/nccf/com/nam/.*nam.*(awip3d).*!(grib2)/ncep/(NAM_84)/#([^/]*)/([0-9]{8})([0-9]{4})(F[0-1]..)/([^/]*)/.*! (......)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/conduit/\3/\5_\6Z_\7_\8-(seq).\1.grib2

### DGEX

      NGRID   ^[LM].E... KWBD ...... !grib2/[^/]*/([^/]*)/#[^/]*/([0-9]{8})([0-9]{4})(F[0-9]{3})/([^/]*)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/noaaport/DGEX/\1_\2_\3Z_\4_\5-(seq).grib2

### NOAAport HRRR

      NGRID   Y.C.[0-9][0-9] KWBY ...... !grib2/[^/]*/[^/]*/#[^/]*/([0-9]{12})F(...)/(.*)/.*
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/noaaport/HRRR/\1_F\2_\3_(seq).grib2
              
### GFS212 40km
      NGRID   ^[LM].R... KWBC ...... !grib2/[^/]*/([^/]*)/#(212)/([0-9]{8})([0-9]{4})(F[0-9]{3})/([^/]*)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/noaaport/GRID\2/\1_\3_\4Z_\5_\6-(seq).grib2
              
### RAP-13km

      NGRID   ^[LM].D... KWBG ...... !grib2/[^/]*/([^/]*)/#([^/]*)/([0-9]{8})([0-9]{4})(F[0-9]{3})/([^/]*)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/noaaport/GRID\2/\1_\3_\4Z_\5_\6-(seq).grib2
              
              
### RTMA 197 (5km)

      NGRID   ^[LM].M... KWBR ...... !grib2/[^/]*/([^/]*)/#([^/]*)/([0-9]{8})([0-9]{4})(F[0-9]{3})/([^/]*)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/noaaport/GRID\2/\1_\3_\4Z_\5_\6-(seq).grib2
              
              
### RTMA-Mosaic (2.5km)

      NGRID   ^[LM].[IQ]... KWBR ...... !grib2/[^/]*/([^/]*)/#([^/]*)/([0-9]{8})([0-9]{4})(F[0-9]{3})/([^/]*)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/noaaport/GRID\2/\1_\3_\4Z_\5_\6-(seq).grib2
              
              
### NamDNG 2.5 and 5km
      NGRID   ^[LM].[IM]... KWBE ...... !grib2/[^/]*/([^/]*)/#([^/]*)/([0-9]{8})([0-9]{4})(F[0-9]{3})/([^/]*)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/noaaport/GRID\2/\1_\3_\4Z_\5_\6-(seq).grib2
              
              
### NAM12 (#218)
      NGRID   ^[LM].B... KWBE ...... !grib2/[^/]*/([^/]*)/#([^/]*)/([0-9]{8})([0-9]{4})(F[0-9]{3})/([^/]*)
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/noaaport/GRID\2/\1_\3_\4Z_\5_\6-(seq).grib2

### CMC

      CMC     CMC_reg_(.*)km_(..........)_P(...).grib2
              FILE    -overwrite -log -close -edex    /awips2/data_store/grib2/cmc/cmc_reg_\1km_\2_P\3.grib2

### FNMOC

      FNMOC   ^US058.*(0018_0056|0022_0179|0027_0186|0060_0188|0063_0187|0110_0240|0111_0179|0135_0240|0078_0200)_(.*)_(.*)_(.*)-.*
              FILE    -log -overwrite -close -edex /awips2/data_store/grib2/fnmoc/US_058_\1_\2_\3_\4-(seq).grib
      
                     
