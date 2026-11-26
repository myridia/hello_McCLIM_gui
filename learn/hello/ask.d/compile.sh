#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Save the hello executable from hello.lisp.
cd "$SCRIPT_DIR" && sbcl --noinform --disable-debugger \
  --eval '(load "hello.lisp")' \
  --eval '(sb-ext:save-lisp-and-die "hello" :toplevel (function main) :executable t)'
