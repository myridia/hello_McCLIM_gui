#!/bin/sh
# id: 8
# group: WINDOWS
# desc: Build - Windows SDL2 executable
. "$(dirname "$0")/lib.sh"

set -e
enter

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) ;;
  *)
    printf "FAIL  Windows build requires MINGW, MSYS, or CYGWIN\n"
    exit 1
    ;;
esac

MCCLIM_BACKEND=${MCCLIM_BACKEND:-sdl2}
export MCCLIM_BACKEND
sh "$ROOT/ask.d/build.sh"
