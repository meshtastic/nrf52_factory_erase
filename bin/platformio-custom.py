#!/usr/bin/env python3
# trunk-ignore-all(ruff/F821)
# trunk-ignore-all(flake8/F821): For SConstruct imports
import sys
from os.path import join

from readprops import readProps

Import("env")
platform = env.PioPlatform()


if platform.name == "nordicnrf52":
    env.AddPostAction("$BUILD_DIR/${PROGNAME}.hex",
                      env.VerboseAction(f"{sys.executable} ./bin/uf2conv.py $BUILD_DIR/firmware.hex -c -f 0xADA52840 -o $BUILD_DIR/firmware.uf2",
                                        "Generating UF2 file"))

Import("projenv")

prefsLoc = projenv["PROJECT_DIR"] + "/version.properties"
verObj = readProps(prefsLoc)
print("Using meshtastic platformio-custom.py, firmware version " + verObj["long"])

# General options that are passed to the C and C++ compilers
projenv.Append(
    CCFLAGS=[
        "-DAPP_VERSION=" + verObj["long"],
        "-DAPP_VERSION_SHORT=" + verObj["short"],
    ]
)
