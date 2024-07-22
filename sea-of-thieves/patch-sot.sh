#!/bin/bash

set -e

if [ "$1" == "libcef" ] && [ -n "$2" ]; then
  # Verify existence of libcef.dll
  libcef="$2/Engine/Binaries/ThirdParty/CEF3/Win64/85.2.0+g94efef2+chromium-85.0.4183.26/Release/libcef.dll"
  if [ ! -f "$libcef" ]; then
    echo "Could not find required Sea of Thieves libcef.dll file"
    exit 1
  fi

  # Since Sea of Thieves does not facilitate for passing `--in-process-gpu` to CEF, the two patches below
  # essentially pretend that this flag was specified (by flipping jumps to no jumps and vice versa). There may
  # be a more elegant way to do this, but at least it prevents the Xbox sign-in window from crashing.
  #
  # CodeWeavers are aware of this issue: bug #18682. Hopefully this will get fixed properly in the future.
  #
  hash=$(md5 -q "$libcef")

  # Sea of Thieves build 14754129
  if [ "$hash" == "6abc2ec28a967bdcd901609067119171" ]; then
    printf "\x75" | dd of="$libcef" bs=1 seek=$((0xd4ccb2)) conv=notrunc status=none
    printf "\x74" | dd of="$libcef" bs=1 seek=$((0x234a2b6)) conv=notrunc status=none
    echo "Successfully patched $libcef (fixes Xbox sign-in window when using WineD3D)"

  elif [ "$hash" == "069504917fed3e225ebe80e5d47b8377" ]; then
    printf "\x74" | dd of="$libcef" bs=1 seek=$((0xd4ccb2)) conv=notrunc status=none
    printf "\x75" | dd of="$libcef" bs=1 seek=$((0x234a2b6)) conv=notrunc status=none
    echo "Restored $libcef (used by Xbox sign-in window)"

  else
    echo "Found an unknown version of libcef.dll (hash: $hash)"
    exit 1
  fi

elif [ "$1" == "cx" ]; then
  # Verify existence of CrossOver.app and advapi32.dll
  crossover="${2:-/Applications/CrossOver.app}"
  advapi32="$crossover/Contents/SharedSupport/CrossOver/lib/wine/x86_64-windows/advapi32.dll"
  if [ ! -d "$crossover" ] || [ ! -f "$advapi32" ]; then
    echo "Could not find CrossOver.app or bundled advapi32.dll"
    exit 1
  fi

  # Wine's implementation of `CredEnumerateW` seems to fetch both generic credentials (registry) as well as
  # host / domain credentials. Sea of Thieves seems to use registry credentials exclusively. On CrossOver macOS
  # the return status of `CredEnumerateW` seems to become `NOT_FOUND` when no host / domain credentials could be
  # found, even when registry credentials were found, which sounds like a bug.
  #
  # Hope to get in touch with CodeWeavers in the future to figure out whether this is by design, or a bug. It
  # seems that Sea of Thieves works fine on Proton, with seemingly the same implementation in place.
  #
  # The patches below remove host / domain credentials retrieval from `CredEnumerateW` altogether, which lets
  # Sea of Thieves fetch its credentials correctly. As `CredEnumerateW` is part of `advapi32.dll` this will
  # affect all bottles and could negatively affect other games / applications.
  #
  hash=$(md5 -q "$advapi32")

  # CrossOver 23.7.1 only
  if [ "$hash" == "b59cb59ea367ec0344222a7f57531c5c" ]; then
    printf "\x75" | dd of="$advapi32" bs=1 seek=$((0xb1ba)) conv=notrunc status=none
    printf "\x75" | dd of="$advapi32" bs=1 seek=$((0xb2cc)) conv=notrunc status=none
    echo "Successfully patched $advapi32 (CrossOver / Wine credential bug)"

  elif [ "$hash" == "3e4f6a851e5444a49b6b5c7dda7f8a87" ]; then
    printf "\x74" | dd of="$advapi32" bs=1 seek=$((0xb1ba)) conv=notrunc status=none
    printf "\x74" | dd of="$advapi32" bs=1 seek=$((0xb2cc)) conv=notrunc status=none
    echo "Restored $advapi32 (CrossOver / Wine credential bug)"

  # CrossOver 24.0.0 and 24.0.4 only
  elif [ "$hash" == "136bd9be7952ad241d22beca92c18fa4" ] || [ "$hash" == "ca17fdd4834bc21bf74e4825d160e600" ]; then
    printf "\x75" | dd of="$advapi32" bs=1 seek=$((0xb092)) conv=notrunc status=none
    printf "\x75" | dd of="$advapi32" bs=1 seek=$((0xb161)) conv=notrunc status=none
    echo "Successfully patched $advapi32 (CrossOver / Wine credential bug)"

  elif [ "$hash" == "118a2b744b10cda352e701b392324f98" ] || [ "$hash" == "c07bfd8967c387b9adf7ae544555c8c5" ]; then
    printf "\x74" | dd of="$advapi32" bs=1 seek=$((0xb092)) conv=notrunc status=none
    printf "\x74" | dd of="$advapi32" bs=1 seek=$((0xb161)) conv=notrunc status=none
    echo "Restored $advapi32 (CrossOver / Wine credential bug)"

  else
    echo "Found an unknown version of advapi32.dll (hash: $hash)"
    exit 1
  fi

else
  echo 'Usage:'
  echo '  ./patch-sot.sh libcef <path/to/Sea of Thieves>'
  echo '  ./patch-sot.sh cx [optional: <path/to/Crossover.app>]'
  exit 1
fi
