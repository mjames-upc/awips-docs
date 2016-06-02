---
layout: default
type: guide
shortname: Docs
title: Default LDM feeds
subtitle: EDEX Admin
---

`/awips2/ldm/etc/ldmd.conf` is the main configuration file for the LDM server, where the EDEX server and default feed types are defined.

At the top of `ldmd.conf`, you can see the **EXEC** lines

    EXEC    "pqact -e"
    EXEC    "edexBridge -s EDEX_HOSTNAME"
  
where `EDEX_HOSTNAME` is set to your local EDEX server with the command `edex setup`.

# Default feed types

Remember than LDM commands such as these require **TAB SEPARATION** between items.

    REQUEST NEXRAD3 ".*" idd.unidata.ucar.edu
    REQUEST FNEXRAD|IDS|DDPLUS|UNIWISC ".*" idd.unidata.ucar.edu
    REQUEST NGRID ".*" idd.unidata.ucar.edu
    REQUEST NOTHER|HDS|NIMAGE ".*" idd.unidata.ucar.edu
    
    REQUEST CONDUIT ".(awip3d|0p50).[0]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[1]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[2]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[3]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[4]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[5]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[6]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[7]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[8]$"   idd.unidata.ucar.edu
    REQUEST CONDUIT ".(awip3d|0p50).[9]$"   idd.unidata.ucar.edu

# Optional feed types

FNMOC and CMC models

    REQUEST FNMOC ".*" idd.unidata.ucar.edu
    REQUEST CMC ".*" idd.unidata.ucar.edu
    
Lightning

    REQUEST        LIGHTNING       ".*"    striker2.atmos.albany.edu
    REQUEST        LIGHTNING       ".*"    idd.unidata.ucar.edu
    
MRMS (with access granted from NSSL)

    REQUEST EXP ".*" 140.90.98.15
  
3.1	Ingest Filter Configuration
Ingest filtering is controlled through the pqact.conf file, which resides in the /usr/local/ldm/etc directory. The general syntax of an entry in the file is as follows:
feedtype TAB Regex Pattern 
TAB action TAB [arg]
Where TAB is an actual TAB. Lines can, and are, split between new lines at a TAB.
Table 3.1-1 is a list of feedtypes that can be used (reference http://www.unidata.ucar.edu/software/ldm/ldm-6.7.1/basics/feedtypes/index.html ).
Table 3.1-1. LDM Feedtypes
Primary Name
Alternate Names
Description
PPS
FT0
Public Products Service 
DDS
FT1, DOMESTIC
Domestic Data Service 
HDS
FT2, HRS
High resolution Data Service
IDS
FT3, INTNL
International Data Service
SPARE
FT4
Reserved for IDD use
UNIWISC
FT5, MCIDAS
Satellite imagery and derived products from the Unidata/Wisconsin Broadcast
PCWS
FT6, ACARS
ACARS data from commercial aircraft
FSL2
FT7, PROFILER
Wind profiler data
FSL3
FT8
Reserved for NOAA/GSD use
FSL4
FT9
Reserved for NOAA/GSD use
FSL5
FT10
Reserved for NOAA/GSD use
GPSSRC
FT11, NMC1, AFOS
SuomiNet GPS data gathering
CONDUIT
FT12, NMC2, NCEPH
NCEP high-resolution model output
FNEXRAD
FT13, NMC3
NEXRAD Level-III composites 
LIGHTNING
FT14,NLDN
Lightning data
WSI
FT15
NEXRAD Level-III (NIDS) radar products and composites from WSI Corporation
DIFAX
FT16
Unidata community-generated replacement for defunct DIFAX feed
FAA604
FT17, FAA, 604
FAA604 products for NWS use (private network), but available for IDD use
GPS
FT18
SuomiNet GPS data
FNMOC
FT19, SEISMIC, NOGAPS
NOGAPS and COAMP model output from FNMOC 
GEM
FT20, CMC
Canadian Meteorological Center GEM model output
NIMAGE
FT21, IMAGE
NOAAport satellite imagery
NTEXT
FT22, TEXT
NOAAport textual products (for future use)
NGRID
FT23, GRID
NOAAport high-resolution model output 
NPOINT
FT24, POINT, NBUFR, BUFR
NOAAport point products (for future use)
NGRAPH
FT25, GRAPH
NOAAport Redbook Graphics (for future use)
NOTHER
FT26, OTHER
NOAAport miscellaneous products (for future use)
NEXRAD3
FT27, NNEXRAD, NEXRAD
NEXRAD Level-III products
NEXRAD2
FT28, CRAFT, NEXRD2
NEXRAD Level-II radar data
NXRDSRC
FT29
NCDC NEXRAD Level-II data archiving 
EXP
FT30
For experiments, testing, etc.
ANY
FT0 | FT1 | FT2 | ... | FT31
Predefined feed set name for any feed type
NONE
--
Predefined feed set name for no feed types (will not match anything)
DDPLUS
FT0 | FT1
Predefined feed set name for PPS or DDS
WMO
FT0 | FT1 | FT2 | FT3
Predefined feed set name for PPS, DDS, HDS, or IDS
UNIDATA
FT0 | FT1 | FT2 | FT3 | FT5
Predefined feed set name for PPS, DDS, HDS, IDS, or UNIWISC
FSL
FT6 | FT7 | FT8 | FT9 | FT10
Predefined feed set name for PCWS, FSL2, FSL3, FSL4, or FSL5
NMC
FT11 | FT12 | FT13
Predefined feed set name for AFOS, NMC2, or NMC3
NPORT
FT22 | FT23 | FT24 | FT25 | FT26
Predefined feed set name for NTEXT, NGRID, NPOINT, NGRAPH, or NOTHER

Regex Pattern  is a regular expression used in pattern matching the LDM stream for ingest. 
Action is the action to take on the product once it arrives. Table 3.1-2 describes the possibilities for action and can be found on LDM’s Web page here: http://www.unidata.ucar.edu/software/ldm/ldm-current/basics/pqact.conf.html
Table 3.1-2. LDM Action Options
Action
Description
NOOP
Don’t do anything with the product.
FILE
Write the data product to a file using the write() function.
STDIOFILE
Write the data product to a file using the fwrite() function.
DBFILE
Write the data product to a database.
EXEC
Execute a program.
PIPE
Write the product to a program’s standard input.

Arg is any optional arguments for the Action and is generally one of the following:
In general, the syntax for the ARG portion of the line in the pqact.conf file is as seen below:
–overwrite –close –log –edex    <tab>	  /store/path

Where:
<tab> indicates hitting the tab key on the keyboard
/store/path is the path the file should be written to disk.
-overwrite indicates overwrite the file (if exists)
-close indicates to close the file after fwrite() function
-log indicates log the product to the ldmd.log
-edex indicates the sending of data over edexBridge for processing


In order to determine the correct FEEDTYPE above, the following command can be run from a downstream LDM host. 
# ./notifyme –h $LDM_HOST –v –l- -p ‘$REGEX’
Where $REGEX is a regular expression that will match against the type of data which is of interest. Once a match is found, it is displayed on the screen as seen in Example 3.1-1.
Example 3.1-1
 Dec 21 15:52:21 notifyme[32196] INFO:     1522 20101221155220.618 IDS|DDPLUS 11247393  SOAK45 KWBC 211549
Dec 21 15:52:21 notifyme[32196] INFO:      408 20101221155220.618     HDS 11247394  SFUS41 KWBC 211545

The example shows the FEEDTYPE in bold type.
AWIPS I customizes only specific patterns based on the localized site. Tables 3.1-3 and 3.1-4  depict information on each, and where to find the corresponding information.
Table 3.1-3. Hydrology Patterns
AWIPS I Pattern
Information Location
AWIPS II LDM Pattern
^SRU[EMSW][1-9]..(Wxxx)
Wxxx from XXX-hydroSiteConfig.txt file in /awips/fxa/data/localization/XXX
IDS|DDPLUS      ^(SRU[EMSW][1-9].) (Wxxx)
SRUSRegCode.KWBC
RegCode from XXX-hydroSiteConfig.txt file in /awips/fxa/data/localization/XXX
IDS|DDPLUS      ^(SRUSRegCode) (KWBC)
FOUS...(Rxxx)
Rxxx from XXX-hydroSiteConfig.txt file in /awips/fxa/data/localization/XXX
IDS|DDPLUS      ^(FOUS..) (Rxxx)
FGUS[57]..(Rxxx)
Rxxx from XXX-hydroSiteConfig.txt file in /awips/fxa/data/localization/XXX
IDS|DDPLUS      ^(FGUS[567].) (Rxxx)
[AF][BS]US...(Wxxx)
Wxxx from XXX-hydroSiteConfig.txt file in /awips/fxa/data/localization/XXX
IDS|DDPLUS      ^([AF][BS]US..) (Wxxx)
AGUS5..(Rxxx)
Rxxx from XXX-hydroSiteConfig.txt file in /awips/fxa/data/localization/XXX
IDS|DDPLUS      ^(AGUS5.) (Rxxx)
AGUS4..(Wxxx)
Wxxx from XXX-hydroSiteConfig.txt file in /awips/fxa/data/localization/XXX
IDS|DDPLUS      ^(AGUS4.) (Wxxx)
[YZ]EI.98.(Rxxx)
Rxxx from XXX-hydroSiteConfig.txt file in /awips/fxa/data/localization/XXX
ANY     ^([YZ]EI.98) (Rxxx)
Note:  An example of the first row in the pqact.conf would look like this:
IDS|DDPLUS	^(SRU[EMSW][1-9].) (Wxxx) (..)(..)(..)
FILE	-overwrite -log -close -edex	/data_store/shef/\4/\1_\2_\3\4\5_(seq).txt
Remember that there are TABs between the different sections of the entry and that Wxxx would be substituted based on the rules above.

Table 3.1-4. Radar Patterns
AWIPS I Pattern
Information Reference
CODE 17 INCLUDE SDUS2??KZZZ
Substitute KZZZ for the reporting site for each radar listed in:
/awips/fxa/data/localizationDataSets/XXX/dialRadars.txt
Reporting sites can be found by issuing the following command:
grep –i xxxy /awips/fxa/data/wmoSiteInfo.txt
Where xxx is the radar ID without the preceding K, P or T.
The following file on DX1 also contains the information needed: 
/awips/fxa/data/localizationDataSets/XXX/acq_wmo_parms.sbn.radar
CODE 17 INCLUDE SDUS3??KZZZ
CODE 17 INCLUDE SDUS4??KZZZ
CODE 17 INCLUDE SDUS5??KZZZ
CODE 17 INCLUDE SDUS7??KZZZ
CODE 17 INCLUDE SDUS8??KZZZ
CODE 17 INCLUDE NXUS6??KZZZ
AWIPS II has only one pattern in the pqact.conf file, which lists all KXXX:
NNEXRAD ^(SDUS[234578].|NXUS6.) (K|P|T)(XXX|XXX|XXX|XXX|XXX)
Change the XXX to match each of the reporting sites for the radars listed in dialRadars.txt file. An example of a full NNEXRAD localized line for site LWX follows. Please note there are only two lines, so word wrap applies (see Appendix A for more detailed information on LDM acquisition patterns):
NNEXRAD    ^(SDUS[234578].|NXUS6.) (K|P|T)(LWX|BGM|CHS|RLX|ILN|CLE|AKQ|JKL|CTP|MHX|MRX|OKX|PHI) (..)(..)(..) /p(...)(...)
      FILE    -overwrite –close –log –edex       /data_store/radar/\2\8/\7/\5\6_\2\8_\7_(seq).rad

Additional patterns can also be found in the acqPatternsAddOn.txt file, which can reside in /awips/fxa/data/localization/XXX or /data/fxa/customFiles. These patterns should also be added to the pqact.conf.xxx file in the proper syntax (where xxx is your site ID). 
Delivered with the AWIPS II LDM rpm is a baselined pqact.conf.template file which should be used as a basis for the active pqact.conf file. It should not be edited; rather, it should be copied into the active pqact.conf file. From there, custom patterns can be concatenated onto the active file.
Note: ADAM platform’s active file is adam-pqact.conf
To manually edit or add a new filter rule, follow these steps. Utilize Appendix A, LDM Ingest Checklist, as a tool to help ensure all the correct information is known before proceeding:
Log into the downstream LDM client host (normally PX2) as user root:
# ssh root@$LDM_DOWNSTREAM
Change directories to the pqact.conf location on the server:
# cd /usr/local/ldm/etc
Edit the pqact.conf using a text editor (shown here is vi):
# vi pqact.conf.xxx
Once you are finished making changes, save the file and exit the editor:
# :wq!
Check to ensure that the edited file still has the proper syntax using the ldmadmin  command:
# su ldm –lc “ldmadmin pqactcheck –f /usr/local/ldm/etc/pqact.conf.xxx”
Expect the phrase “syntactically correct” for each file you have configured in ldmadmin-pl.conf
Concatenate this file with the pqact.conf.template file to create the active pqact.conf file:
# cat pqact.conf.template pqact.conf.xxx > pqact.conf
Ensure the proper ownership and permissions:
# chown ldm:fxalpha /usr/local/ldm/etc/pqact.conf
Signal the LDM server to re-read the configuration files:
# su ldm –lc “ldmadmin pqactHUP”

