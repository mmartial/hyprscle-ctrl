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
cfile="/etc/hyprspace/hs.yaml"
rfile="/app/config.yml"
if [ ! -f ${cfile} ]; then
    ${tool} init hs
    if [ ! -f ${cfile} ]; then
      echo "Failed to initialize"
      exit 1
    fi
    if [ -f ${rfile} ]; then
      cp ${cfile} /tmp/hs.yaml
      perl /app/repl.pl ${rfile} ${cfile} | tee /tmp/hs.yaml.mod
      cp /tmp/hs.yaml.mod ${cfile}
    fi
fi

# Start it
#$tool up hs0 &

# Configure iptables for 10.11.12.x
# [...]

# Wait until manual Stop
sleep infinity
