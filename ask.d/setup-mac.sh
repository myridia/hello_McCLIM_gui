#!/bin/sh
# id: 1
# group: MAC
# desc: Setup - macOS (SDL2)
. "$(dirname "$0")/lib.sh"

set -e
MCCLIM_SETUP_PLATFORM=mac
MCCLIM_BACKEND=${MCCLIM_BACKEND:-sdl2}
export MCCLIM_SETUP_PLATFORM MCCLIM_BACKEND
exec sh "$ROOT/ask.d/setup.sh"
