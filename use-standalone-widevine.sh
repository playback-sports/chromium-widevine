#!/bin/bash

# Find Chromium
CHROMIUM_DIR="$(/bin/sh ./find-chromium.sh)"
if [ -z "$CHROMIUM_DIR" ]; then
	exit 1
fi

# Get Widevine archive
/bin/sh ./fetch-latest-widevine.sh -o ./widevine.zip
# Expected directory structure:
#	  widevine.zip
#	  ├── LICENSE.txt
#	  ├── manifest.json
#	  └── libwidevinecdm.so

# Extract Widevine and recreate this directory structure under the Chromium directory:
#	  /usr/lib/chromium/WidevineCdm
#	  ├── LICENSE
#	  ├── manifest.json
#	  └── _platform_specific
#		  └── linux_x64
#				└── libwidevinecdm.so

mkdir -p "$CHROMIUM_DIR/WidevineCdm/_platform_specific/linux_x64"
unzip -p widevine.zip LICENSE.txt | dd status=none of="${CHROMIUM_DIR}/WidevineCdm/LICENSE"
unzip -p widevine.zip manifest.json | dd status=none of="${CHROMIUM_DIR}/WidevineCdm/manifest.json"
unzip -p widevine.zip libwidevinecdm.so | dd status=none of="${CHROMIUM_DIR}/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"
find "$CHROMIUM_DIR/WidevineCdm" -type d -exec chmod 0755 '{}' \;
find "$CHROMIUM_DIR/WidevineCdm" -type f -exec chmod 0644 '{}' \;

# clean up
rm ./widevine.zip
