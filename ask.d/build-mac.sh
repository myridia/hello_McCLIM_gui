#!/bin/sh
# id: 5
# group: BUILD
# desc: Build - macOS SDL2 executable
. "$(dirname "$0")/lib.sh"

set -e
enter

case "$(uname -s)" in
  Darwin*) ;;
  *)
    printf "FAIL  macOS build requires Darwin\n"
    exit 1
    ;;
esac

MCCLIM_BACKEND=${MCCLIM_BACKEND:-sdl2}
export MCCLIM_BACKEND
sh "$ROOT/ask.d/build.sh"
