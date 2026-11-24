#!/bin/sh
# id: 2
# group: SETUP
# desc: Build - save SBCL executable
. "$(dirname "$0")/lib.sh"

set -e
enter

rm -rf bin dist/mcclim
mkdir -p bin dist/mcclim

sbcl --non-interactive \
  --eval '(defparameter cl-user::*auto-start* nil)' \
  --load main.lisp \
  --eval '(sb-ext:save-lisp-and-die "bin/mcclim" :toplevel (function clim-user:main) :executable t :compression t)'

exe=bin/mcclim
[ -e "$exe.exe" ] && exe="$exe.exe"
cp "$exe" "dist/mcclim/${exe##*/}"
ttf=$(find "$HOME/quicklisp/dists/quicklisp/software" -path '*/dejavu-fonts-ttf-*/ttf/DejaVuSans.ttf' -print -quit)
if [ -n "$ttf" ]; then
  cp "$ttf" dist/mcclim/DejaVuSans.ttf
fi
printf "ok    dist/mcclim\n"
