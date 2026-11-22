#!/bin/sh
# id: 2
# group: SETUP
# desc: Build - save SBCL executable
. "$(dirname "$0")/lib.sh"

set -e
enter

rm -rf bin dist/hello_McCLIM_gui
mkdir -p bin dist

sbcl --non-interactive \
  --eval '(setf cl-user::*auto-start* nil)' \
  --load main.lisp \
  --eval '(sb-ext:save-lisp-and-die "bin/hello_McCLIM_gui" :toplevel (function clim-user:main) :executable t :compression t)'

exe=bin/hello_McCLIM_gui
[ -e "$exe.exe" ] && exe="$exe.exe"
cp "$exe" "dist/hello_McCLIM_gui/${exe##*/}"
printf "ok    dist/hello_McCLIM_gui\n"
