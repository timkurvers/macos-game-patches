#!/bin/bash

set -e

if [ ! -f "$1" ]; then
  echo 'Usage: ./patch-tomb123.sh <path/to/tomb123.exe>'
  exit 1
fi

# In the OpenGL initialization code (address 0x14000efe0), a GL context is created:
#
# > 14000f350  f30f7f4590         movdqu  xmmword [rbp-0x70 {attribList}], xmm0
# > 14000f355  c745a026910000     mov     dword [rbp-0x60 {var_98}], 0x9126
# > 14000f35c  488975a4           mov     qword [rbp-0x5c {var_94}], rsi  {0x1}
# > 14000f360  41ffd7             call    r15
#
# The first line in the assembly above memcopies major/minor version 3.2, whereas the middle two instructions
# set WGL_CONTEXT_PROFILE_MASK_ARB (0x9126) to 1, indicating a core profile.
#
# There is no space for us to enable forwards-compatibility mode, which macOS requires. Wine however, defaults
# to a 3.2 core profile, so use that space to instead set WGL_CONTEXT_FLAGS_ARB (0x2094) to 2 piggybacking on
# the `rdi` register, which happens to contain `0000000015010052` at this point.
#

hash=$(md5 -q "$1")

if [ "$hash" == "769b1016f945167c48c6837505e37748" ]; then
  printf "\x94\x20" | dd of="$1" bs=1 seek=59224 conv=notrunc status=none
  printf "\x7D" | dd of="$1" bs=1 seek=59230 conv=notrunc status=none
  echo "Successfully patched $1"

elif [ "$hash" == "a3757251c91d12c15d0ba98e927a27e4" ]; then
  printf "\x26\x91" | dd of="$1" bs=1 seek=59224 conv=notrunc status=none
  printf "\x75" | dd of="$1" bs=1 seek=59230 conv=notrunc status=none
  echo "Restored $1"

else
  echo "Found an unknown version of tomb123.exe"
  exit 1
fi
