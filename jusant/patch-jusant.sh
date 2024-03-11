#!/bin/bash

set -e

if [ ! -f "$1" ]; then
  echo 'Usage: ./patch-jusant.sh <path/to/ASC-Win64-Shipping.exe>'
  exit 1
fi

# In RHIInit (address 0x39b9c80), the MessageBox is shown and the game exits:
#
# > 0x39ba165  e816060100         call    JusantSpecificDX12RequirementsMessageBox
# > 0x39ba16a  b101               mov     cl, 0x1
# > 0x39ba16c  e8df9bdffe         call    FPlatformMisc::RequestExitWithStatus
#
# By NOPing out both of the above calls, we effectively bypass the check entirely.
#

hash=$(md5 -q "$1")

# Jusant build 13334122
if [ "$hash" == "3b45cc5aae7d65ecbfe24b3c25fed3f1" ]; then
  printf "\x90\x90\x90\x90\x90" | dd of="$1" bs=1 seek=$((0x39BA165)) conv=notrunc status=none
  printf "\x90\x90\x90\x90\x90" | dd of="$1" bs=1 seek=$((0x39BA16C)) conv=notrunc status=none
  echo "Successfully patched $1"

elif [ "$hash" == "1028b1a7a2824c5b728d3f95258377c0" ]; then
  printf "\xE8\x16\x06\x01\x00" | dd of="$1" bs=1 seek=$((0x39BA165)) conv=notrunc status=none
  printf "\xE8\x1F\x9D\xDF\xFE" | dd of="$1" bs=1 seek=$((0x39BA16C)) conv=notrunc status=none
  echo "Restored $1"

else
  echo "Found an unknown version of ASC-Win64-Shipping.exe"
  exit 1
fi
