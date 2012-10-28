#!/bin/sh

PLIST=/Library/LaunchAgents/org.monome.serialosc.plist
[ -f $PLIST ] && launchctl unload $PLIST || /bin/true
