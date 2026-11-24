#!/bin/sh
# id: 2
# group: SETUP
# desc: Build - save SBCL executable
. "$(dirname "$0")/lib.sh"

set -e
enter

rm -rf bin dist/mcclim
mkdir -p bin dist/mcclim

ttf=$(find "$HOME/quicklisp/dists/quicklisp/software" -path '*/dejavu-fonts-ttf-*/ttf/DejaVuSans.ttf' -print -quit)
MCCLIM_FONT="$ttf" sbcl --non-interactive \
  --eval '(defparameter cl-user::*bundled-font-bytes* (with-open-file (s (sb-ext:posix-getenv "MCCLIM_FONT") :element-type (quote (unsigned-byte 8))) (let* ((n (file-length s)) (b (make-array n :element-type (quote (unsigned-byte 8))))) (read-sequence b s) b)))' \
  --eval '(defparameter cl-user::*auto-start* nil)' \
  --load main.lisp \
  --eval '(sb-ext:save-lisp-and-die "bin/mcclim" :toplevel (function clim-user:main) :executable t :compression t)'

exe=bin/mcclim
[ -e "$exe.exe" ] && exe="$exe.exe"
cp "$exe" "dist/mcclim/${exe##*/}"
printf "ok    dist/mcclim\n"
