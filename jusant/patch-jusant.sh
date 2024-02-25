#!/bin/bash

set -e

if [ ! -f "$1" ]; then
  echo 'Usage: ./patch-jusant.sh <path/to/ASC-Win64-Shipping.exe>'
  exit 1
fi

# Verify Jusant binary (prevent double patching)
hash=$(md5 -q "$1")
if [ "$hash" != "09516e36c1f7e64b77b60fa382d350a0" ]; then
  echo "Exiting as this file is not the main Jusant binary or already patched"
  exit 1
fi

# Make a copy of the original
cp "$1" "$1.bak"

# In RHIInit (address 0x39b82a0), the MessageBox is shown and the game exits:
#
# > 0x39b8785  e816060100         call    JusantSpecificDX12RequirementsMessageBox
# > 0x39b878a  b101               mov     cl, 0x1
# > 0x39b878c  e8df9bdffe         call    FPlatformMisc::RequestExitWithStatus
#
# By NOPing out both of the above calls, we effectively bypass the check entirely.

printf "\x90\x90\x90\x90\x90" | dd of="$1" bs=1 seek=60524421 conv=notrunc
printf "\x90\x90\x90\x90\x90" | dd of="$1" bs=1 seek=60524428 conv=notrunc

echo
echo "Successfully patched $1"
