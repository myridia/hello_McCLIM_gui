#!/bin/sh
# id: 4
# group: LINUX
# desc: Setup - Linux (CLX)
. "$(dirname "$0")/lib.sh"

set -e
MCCLIM_SETUP_PLATFORM=linux
MCCLIM_BACKEND=${MCCLIM_BACKEND:-clx}
export MCCLIM_SETUP_PLATFORM MCCLIM_BACKEND
exec sh "$ROOT/ask.d/setup.sh"
