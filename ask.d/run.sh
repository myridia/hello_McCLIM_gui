#!/bin/sh
. "$(dirname "$0")/lib.sh"

enter
sbcl --script main.lisp
