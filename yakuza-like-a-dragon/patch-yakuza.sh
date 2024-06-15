#!/bin/sh

HASH_DB=("4c2534598b5c85ee571a21a63ab76c9e2d0d2462909033225eb4a542f079022359f014302061c27f01299f0852253cc196f7b9cfe3f908d1660a1a83cc8531e9:startup.exe"
         "f4f0086ca41f7854cd1eb21c38ddf261103cf2dede3cffc2324c199f0bd9786e8d5c94994da7986cf2c4eb92e4e36fdc5532cc87a113e0c13777aa53240ff9be:YakuzaGOG.exe" 
         "4b150e33788ce15e6f510e16b82ea9939475ef04a321817750dffc2f08fbdb2f20850be5c249b4c9b1a7def8950d004d92326003d9ba74f3b4bd8129384f22f7:YakuzaSteam.exe")

PATCH_DB=(
    "startup.exe:0x42c:\xe1\x1c\x73\x31"
    "YakuzaGOG.exe:0xf4375c:\x1c\x73\x2d\xff"
    "YakuzaSteam.exe:0xf4374c:\x1c\x73\x2d\xff"
)

# First we check $1 for any file path. If not we show a drop area prompt
if [ -z "$1" ]; then
    echo "Please drag and drop an executable file here..."
    read -r file
    if [ -z "$file" ]; then
        exit
    fi
else
    file="$1"
fi

file_hash=$(shasum -a 512 "$file" | cut -d " " -f 1)

for hash in "${HASH_DB[@]}"; do
    if [ "$file_hash" = "${hash%%:*}" ]; then
        patcher="${hash##*:}"
    fi
done

if [ -z "$patcher" ]; then
    echo "File not found in database"
    exit
fi

# Patch string is in format file:offset:patch
for patch in "${PATCH_DB[@]}"; do
    patchstr="${patch%%:*}"
    if [ "$patchstr" = "$patcher" ]; then
        offset="${patch#*:}"
        offset="${offset%%:*}"
        hexpatch="${patch#*:}"
        hexpatch="${hexpatch#*:}"
        break
    fi
done

echo "Patching $file"

cp "$file" "$file.bak"
#overwrite the bytes at the specified offset with the patch
printf "$hexpatch" | dd of="$file" bs=1 seek="$offset" conv=notrunc status=none