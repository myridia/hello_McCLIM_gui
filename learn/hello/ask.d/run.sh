#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Run the hello script.
cd "$SCRIPT_DIR" && sbcl --script hello.lisp
