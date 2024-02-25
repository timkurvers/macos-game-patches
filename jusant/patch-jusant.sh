#!/bin/bash

set -e

if [ ! -f "$1" ]; then
  echo 'Usage: ./patch-jusant.sh <path/to/ASC-Win64-Shipping.exe>'
  exit 1
fi

# In RHIInit (address 0x39b82a0), the MessageBox is shown and the game exits:
#
# > 0x39b8785  e816060100         call    JusantSpecificDX12RequirementsMessageBox
# > 0x39b878a  b101               mov     cl, 0x1
# > 0x39b878c  e8df9bdffe         call    FPlatformMisc::RequestExitWithStatus
#
# By NOPing out both of the above calls, we effectively bypass the check entirely.
#

hash=$(md5 -q "$1")

if [ "$hash" == "09516e36c1f7e64b77b60fa382d350a0" ]; then
  printf "\x90\x90\x90\x90\x90" | dd of="$1" bs=1 seek=60524421 conv=notrunc status=none
  printf "\x90\x90\x90\x90\x90" | dd of="$1" bs=1 seek=60524428 conv=notrunc status=none
  echo "Successfully patched $1"

elif [ "$hash" == "4d38e275c8526c68947e2e34ed5c44a2" ]; then
  printf "\xE8\x16\x06\x01\x00" | dd of="$1" bs=1 seek=60524421 conv=notrunc status=none
  printf "\xE8\xDF\x9B\xDF\xFE" | dd of="$1" bs=1 seek=60524428 conv=notrunc status=none
  echo "Restored $1"

else
  echo "Found an unknown version of ASC-Win64-Shipping.exe"
  exit 1
fi
