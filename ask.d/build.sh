#!/bin/sh
# id: 2
# group: SETUP
# desc: Build - save SBCL executable
. "$(dirname "$0")/lib.sh"

set -e
enter

rm -rf bin dist/mcclim
mkdir -p bin dist/mcclim

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    compression=nil
    application=' :application-type :gui'
    ;;
  *)
    compression=t
    application=
    ;;
esac

sbcl --non-interactive \
  --eval '(defparameter cl-user::*auto-start* nil)' \
  --load main.lisp \
  --eval '(defparameter cl-user::*bundled-font-bytes* (with-open-file (s (cl-dejavu:font-pathname "DejaVuSans.ttf") :element-type (quote (unsigned-byte 8))) (let* ((n (file-length s)) (b (make-array n :element-type (quote (unsigned-byte 8))))) (read-sequence b s) b)))' \
  --eval "(sb-ext:save-lisp-and-die \"bin/mcclim\" :toplevel (function clim-user:main) :executable t :compression $compression$application)"

exe=bin/mcclim
[ -e "$exe.exe" ] && exe="$exe.exe"
cp "$exe" "dist/mcclim/${exe##*/}"
if [ -f vendor/sdl2/SDL2.dll ]; then
  cp vendor/sdl2/SDL2.dll dist/mcclim/SDL2.dll
fi
printf "ok    dist/mcclim\n"
