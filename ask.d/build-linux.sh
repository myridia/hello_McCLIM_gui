#!/bin/sh
# id: 4
# group: BUILD
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
"$ROOT/ask.d/build.sh"
