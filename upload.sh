#!/bin/bash

set -xe

OUT="$(realpath "$2" 2>/dev/null || echo 'out')"
ZIP="UBPORT_RMX2020.zip"
FLASHABLE="ubports_RMX2020_flashable.zip"

# make flashable zip
git clone https://gitlab.com/ubport_rmx2020/flashable_zip_maker.git
bash flashable_zip_maker/flashable_zip.sh $OUT

# make zip of artifacts 

[ -d "$OUT" ] && zip -r9 "$ZIP" "$OUT/system.img" "$OUT/boot.img"

# upload zip to transfer
[ -f "$ZIP" ] && curl -sL https://git.io/file-transfer | sh && ./transfer wet $ZIP | tee upload.log

# upload flashable zip to transfer
[ -f "$OUT/$FLASHABLE" ] && curl -sL https://git.io/file-transfer | sh && ./transfer wet $OUT/$FLASHABLE | tee -a upload.log

# make a log file for link of download
cp upload.log "$OUT"

