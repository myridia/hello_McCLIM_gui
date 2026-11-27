#!/bin/sh
. "$(dirname "$0")/lib.sh"

set -e
enter

"$ROOT/ask.d/clean.sh"
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

lower_macos_target() {
  file=$1
  if command -v codesign >/dev/null 2>&1; then
    codesign --remove-signature "$file" >/dev/null 2>&1 || true
  fi
  if command -v xcrun >/dev/null 2>&1; then
    target="$file.macos-target"
    rm -f "$target"
    if xcrun vtool -show-build "$file" 2>/dev/null | grep -q 'LC_BUILD_VERSION'; then
      xcrun vtool -set-build-version macos 11.0 11.0 -replace -output "$target" "$file"
    elif xcrun vtool -show-build "$file" 2>/dev/null | grep -q 'LC_VERSION_MIN_MACOSX'; then
      xcrun vtool -set-version-min macos 11.0 11.0 -replace -output "$target" "$file"
    else
      cp -f "$file" "$target"
    fi
    mv "$target" "$file"
    chmod 755 "$file"
    if command -v codesign >/dev/null 2>&1; then
      codesign --force --sign - "$file" >/dev/null 2>&1 || true
    fi
  fi
}

copy_mac_dylib() {
  name=$1
  formula=$2
  inspect=$3
  [ -f "$inspect" ] || return 0
  dep=$(otool -L "$inspect" 2>/dev/null | awk -v needle="$name" 'index($0, needle) { print $1; exit }')
  [ -n "$dep" ] || return 0
  prefix=$(brew --prefix "$formula" 2>/dev/null || true)
  for src in "$prefix/lib/$name" "/usr/local/opt/$formula/lib/$name" "/opt/homebrew/opt/$formula/lib/$name"; do
    [ -f "$src" ] || continue
    dst="dist/mcclim/$name"
    rm -f "$dst"
    cp -f "$src" "$dst"
    chmod 755 "$dst"
    lower_macos_target "$dst"
    break
  done
}

case "$(uname -s)" in
  Darwin*)
    copy_mac_dylib libzstd.1.dylib zstd "$exe"
    if [ "${MCCLIM_BACKEND:-}" = sdl2 ]; then
      copy_mac_dylib libSDL2-2.0.0.dylib sdl2 "$exe"
      copy_mac_dylib libSDL3.dylib sdl3 dist/mcclim/libSDL2-2.0.0.dylib
    fi
    lower_macos_target "$exe"
    ;;
esac

rm -f "dist/mcclim/${exe##*/}"
cp -f "$exe" "dist/mcclim/${exe##*/}"
if [ -f vendor/sdl2/SDL2.dll ]; then
  rm -f dist/mcclim/SDL2.dll
  cp -f vendor/sdl2/SDL2.dll dist/mcclim/SDL2.dll
fi
printf "ok    dist/mcclim\n"
