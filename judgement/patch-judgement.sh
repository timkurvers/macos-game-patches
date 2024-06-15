#!/bin/ sh

HASH_DB=("b567b125dc10b2be3d8bd3eace33991a2ab2081a18f96bc632175f19f44c7d23bebcc4d7ee1e59eaf337118cbda0e2e1876c4d335578bd1629ee0289d13e82cb:startup.exe"
         "4693449227d0e7fe062d8daed828724c8921ef9233ca79d6b4011b768f4875fd8cab1563978c5c99459ab1a222f210f5a5790d02d6669833fa02c2587e4fb8f4:JudgementSteam.exe")

PATCH_DB=(
    "startup.exe:0x42c:\xe1\x1c\x73\x31"
    "JudgementSteam.exe:0xc5e18c:\x1c\x73\x2a\xff"
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