#!/bin/bash

set -e

if [ ! -f "$1" ]; then
  echo 'Usage: ./patch-jusant.sh <path/to/ASC-Win64-Shipping.exe>'
  exit 1
fi

# In RHIInit (file offset 0x47777a0), the MessageBox is shown and the game exits:
#
# > 0x4777c1f  e84c8b0300         call    JusantSpecificDX12RequirementsMessageBox
# > 0x4777c24  b101               mov     cl, 0x1
# > 0x4777c26  e8055ad4fe         call    FPlatformMisc::RequestExitWithStatus
#
# By NOPing out both of the above calls, we effectively bypass the check entirely.
#

hash=$(md5 -q "$1")

# Jusant build 14182642
if [ "$hash" == "139820f43fd68aeeee66ac1cb3bdd7d0" ]; then
  printf "\x90\x90\x90\x90\x90" | dd of="$1" bs=1 seek=$((0x4777c1f)) conv=notrunc status=none
  printf "\x90\x90\x90\x90\x90" | dd of="$1" bs=1 seek=$((0x4777c26)) conv=notrunc status=none
  echo "Successfully patched $1"

elif [ "$hash" == "1c07bd1165eb4865563169807e095d02" ]; then
  printf "\xe8\x4c\x8b\x03\x00" | dd of="$1" bs=1 seek=$((0x4777c1f)) conv=notrunc status=none
  printf "\xe8\x05\x5a\xd4\xfe" | dd of="$1" bs=1 seek=$((0x4777c26)) conv=notrunc status=none
  echo "Restored $1"

else
  echo "Found an unknown version of ASC-Win64-Shipping.exe (hash: $hash)"
  exit 1
fi
