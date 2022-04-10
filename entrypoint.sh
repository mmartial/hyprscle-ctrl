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
    echo "[*****] No configuration file (${cifle}) found, generating one"
    ${tool} init hs
    if [ ! -f ${cfile} ]; then
      echo "Failed to initialize"
      exit 1
    fi
    if [ -f ${rfile} ]; then
      echo "[*****] Specialization file (${rfile}) found, applying"
      cp ${cfile} /tmp/hs.yaml
      perl /app/repl.pl ${rfile} ${cfile} | tee /tmp/hs.yaml.mod
      cp /tmp/hs.yaml.mod ${cfile}
    fi
fi

if [ ! -f ${cfile} ]; then
  echo "[*****] No configuration file (${cfile}) found, aborting"
  exit 1
fi
echo "[*****] Configuration file: ${cfile}"
cat ${cfile}
echo "[*****] End configuration file"
echo ""

# Start it
$tool up hs &

##  Configure iptables for 10.11.12.x
# Allow previously established connection
# iptables -A INPUT -s 10.11.12.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
# Allow .11 to access ssh
# iptables -A INPUT -s 10.11.12.11/32 -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT 
# Drop any other request from anyone on the HP range
# iptables -I INPUT -m iprange --src-range 10.11.12.2-10.11.12.255 -j DROP

# Wait until manual Stop
sleep infinity
