#!/bin/sh
# id: 6
# group: LINUX
# desc: Build - Linux CLX executable
. "$(dirname "$0")/lib.sh"

set -e
enter

case "$(uname -s)" in
  Linux*) ;;
  *)
    printf "FAIL  Linux build requires Linux\n"
    exit 1
    ;;
esac

MCCLIM_BACKEND=${MCCLIM_BACKEND:-clx}
export MCCLIM_BACKEND
sh "$ROOT/ask.d/build.sh"
