---
layout: default
type: guide
shortname: Docs
title: Distributed EDEX Install
---

# Two-server Install (LDM and EDEX)

## ldm server (10.0.0.4)

A small server to run the LDM, write data files to `/awips2/data_store`, and send messages to Qpid via *edexBridge*.

To install:

	yum groupinstall awips2-ldm-server

Then edit the file `/awips2/ldm/etc/ldmd.conf` to define the **edexBridge** server nane:

	EXEC    "edexBridge -s 10.0.0.5"

And then to run (as root or user awips):

	ldmadmin start

## edex server (10.0.0.5)

Our EDEX server has port 5672 open in iptables to accept Qpid messages from 10.0.0.4.  The standard EDEX server install works here, only we will start everything *but* the LDM.

	yum groupinstall awips2-server

and then to start all base services (no LDM)

	edex start base



