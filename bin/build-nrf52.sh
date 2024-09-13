#!/usr/bin/env bash

set -e

VERSION=$(bin/buildinfo.py long)
SHORT_VERSION=$(bin/buildinfo.py short)

OUTDIR=release

rm -r $OUTDIR/* || true

# Important to pull latest version of libs into all device flavors, otherwise some devices might be stale
platformio pkg update -e $1

echo "Building for $1 with $PLATFORMIO_BUILD_FLAGS"
rm -f .pio/build/$1/firmware.*

# The shell vars the build tool expects to find
export APP_VERSION=$VERSION

basename=lr1110_fw_updater-$1-$VERSION

pio run --environment $1 # -v
SRCELF=.pio/build/$1/firmware.elf
cp $SRCELF $OUTDIR/$basename.elf

echo "Generating NRF52 dfu file"
DFUPKG=.pio/build/$1/firmware.zip
cp $DFUPKG $OUTDIR/$basename-ota.zip

echo "Generating NRF52 uf2 file"
SRCHEX=.pio/build/$1/firmware.hex

bin/uf2conv.py $SRCHEX -c -o $OUTDIR/$basename.uf2 -f 0xADA52840
