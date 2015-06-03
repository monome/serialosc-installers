#!/bin/sh

PLIST=/Library/LaunchAgents/org.monome.serialosc.plist
[ -f $PLIST ] && launchctl unload $PLIST || /bin/true
rm -f $PLIST

rm -f /usr/local/bin/serialoscd
rm -rf /usr/local/lib/monome
rm -f /usr/local/include/monome.h
rm -f /usr/local/lib/liblo*dylib
rm -f /usr/local/lib/libmonome*dylib
