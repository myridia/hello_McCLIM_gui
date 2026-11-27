#!/bin/sh
# id: 1
# group: SETUP
# desc: Setup - Linux
. "$(dirname "$0")/lib.sh"

set -e
MCCLIM_SETUP_PLATFORM=linux
MCCLIM_BACKEND=${MCCLIM_BACKEND:-clx}
export MCCLIM_SETUP_PLATFORM MCCLIM_BACKEND
exec sh "$ROOT/ask.d/setup.sh"
