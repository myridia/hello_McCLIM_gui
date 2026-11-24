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
  --eval '(defparameter cl-user::*bundled-font-bytes* (with-open-file (s (cl-dejavu:font-pathname "DejaVuSans.ttf") :element-type (quote (unsigned-byte 8))) (let* ((n (file-length s)) (b (make-array n :element-type (quote (unsigned-byte 8))))) (read-sequence b s) b)))' \
  --eval '(sb-ext:save-lisp-and-die "bin/mcclim" :toplevel (function clim-user:main) :executable t :compression t)'

exe=bin/mcclim
[ -e "$exe.exe" ] && exe="$exe.exe"
cp "$exe" "dist/mcclim/${exe##*/}"
printf "ok    dist/mcclim\n"
