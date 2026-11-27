#!/bin/sh
. "$(dirname "$0")/lib.sh"

set -e
enter

fail() {
  printf 'FAIL  %s\n' "$1" >&2
  exit 1
}

setup_task=1
dist_dir=dist/mcclim

sh "$ROOT/ask.d/clean.sh"
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

brew_lib_path() {
  name=$1
  formula=$2
  formulas=$2
  [ "$2" = sdl2 ] && formulas='sdl2 sdl2-compat'
  for f in $formulas; do
    prefix=$(brew --prefix "$f" 2>/dev/null || true)
    for base in "$prefix" "/opt/homebrew/opt/$f" "/usr/local/opt/$f"; do
      [ -n "$base" ] || continue
      [ -f "$base/lib/$name" ] || continue
      printf '%s\n' "$base/lib/$name"
      return 0
    done
  done
  return 1
}

prepare_mac_dylib() {
  file=$1
  name=$2
  command -v install_name_tool >/dev/null 2>&1 || return 0
  install_name_tool -id "@rpath/$name" "$file" >/dev/null 2>&1 || true
  install_name_tool -add_rpath @loader_path "$file" >/dev/null 2>&1 || true
}

relocate_mac_dylib_dep() {
  file=$1
  needle=$2
  command -v otool >/dev/null 2>&1 || return 0
  command -v install_name_tool >/dev/null 2>&1 || return 0
  old=$(otool -L "$file" 2>/dev/null | awk -v needle="$needle" 'index($0, needle) { print $1; exit }')
  [ -n "$old" ] || return 0
  case "$old" in
    @rpath/*) return 0 ;;
  esac
  install_name_tool -change "$old" "@rpath/${old##*/}" "$file" >/dev/null 2>&1 || true
}

copy_dylib_file() {
  src=$1
  name=$2
  dst="$dist_dir/$name"
  rm -f "$dst"
  cp -f "$src" "$dst"
  chmod 755 "$dst"
  prepare_mac_dylib "$dst" "$name"
  lower_macos_target "$dst"
}

copy_brew_dylib() {
  name=$1
  formula=$2
  src=$(brew_lib_path "$name" "$formula") || return 1
  copy_dylib_file "$src" "$name"
}

copy_mac_sdl_dylibs() {
  copy_brew_dylib libSDL2-2.0.0.dylib sdl2 || fail "libSDL2-2.0.0.dylib missing; run task $setup_task in ask.sh"
  copy_brew_dylib libSDL2.dylib sdl2 || fail "libSDL2.dylib missing; run task $setup_task in ask.sh"

  sdl2_file="$dist_dir/libSDL2-2.0.0.dylib"
  sdl3_dep=$(otool -L "$sdl2_file" 2>/dev/null | awk '/libSDL3/ { n=$1; sub(".*/", "", n); print n; exit }')
  [ -n "$sdl3_dep" ] || sdl3_dep=libSDL3.dylib
  sdl3_src=$(brew_lib_path "$sdl3_dep" sdl3 || brew_lib_path libSDL3.dylib sdl3 || true)
  [ -n "$sdl3_src" ] || fail "libSDL3.dylib missing; run task $setup_task in ask.sh"
  sdl3_name=${sdl3_src##*/}
  copy_dylib_file "$sdl3_src" "$sdl3_name"

  for file in "$sdl2_file" "$dist_dir/libSDL2.dylib"; do
    [ -f "$file" ] || continue
    relocate_mac_dylib_dep "$file" libSDL3
    lower_macos_target "$file"
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
