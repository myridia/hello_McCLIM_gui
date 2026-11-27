#!/bin/sh
# id: 3
# group: SETUP
# desc: Setup - Windows (SDL2)
. "$(dirname "$0")/lib.sh"

set -e
MCCLIM_SETUP_PLATFORM=windows
MCCLIM_BACKEND=${MCCLIM_BACKEND:-sdl2}
export MCCLIM_SETUP_PLATFORM MCCLIM_BACKEND
exec sh "$ROOT/ask.d/setup.sh"
