#!/bin/bash

set -e

if [ ! -d /dev/net ]; then mkdir -p /dev/net; fi
if [ ! -c /dev/net/tun ]; then mknod /dev/net/tun c 10 200; fi

# Confirm we have the tool
tool="/usr/local/bin/hyprspace"
if [ ! -f ${tool} ]; then
  echo "Missing tool: ${tool}"
  exit 1
fi
if [ ! -x ${tool} ]; then
  echo "Tool (${tool}) is not executable"
  exit 1
fi

# Prep a config file
cfile="/etc/hyprspace/hs0.yaml"
if [ ! -f ${cfile} ]; then
    ${tool} init hs0
    if [ ! -f ${cfile} ]; then
      echo "Failed to initialize"
      exit 1
    fi
    gawk -i inplace '{ gsub(/10\.1\.1\.1/,"10.11.12.1") }; { print }' ${cfile}
fi

# Start it
#$tool up hs0 &

# Configure iptables for 10.11.12.x
# [...]

# Wait until manual Stop
sleep infinity
