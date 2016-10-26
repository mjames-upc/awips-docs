---
layout: default
type: guide
shortname: Docs
title: GFE/EDEX Install and Config 
---

A non-operational version of the AWIPS Graphical Forecast Editor (GFE) server can be installed on top of an existing EDEX server with the command

	yum groupinstall awips2-gfe-server

# Start and Stop

The GFE server starts and stop along with AWIPS EDEX.  After installing the above group, run

	edex stop
	edex start

and then watch the EDEX log for GFE site activation

	edex log 

	INFO  [pool-2-thread-1] GFESiteActivation: EDEX - Activating BOU...
	INFO  [pool-2-thread-1] GFESiteActivation: EDEX - IFPServerConfigManager initializing...
	INFO  [pool-2-thread-1] GFESiteActivation: EDEX - Activating IFPServer...A
	...
	INFO  [pool-2-thread-1] GFESiteActivation: EDEX - Adding BOU to active sites list.
	INFO  [pool-2-thread-1] GFESiteActivation: EDEX - BOU successfully activated


# Localization

The localization site is defined in `/awips2/edex/bin/setup.env` and defaults to BOU (Boulder, Colorado)

	export AW_SITE_IDENTIFIER=BOU

