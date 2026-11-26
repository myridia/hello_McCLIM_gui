#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

show_menu() {
  printf "%s\n" '  ┌─────┬──────────────────────────────────────────────┐'
  printf "%s\n" '  │  ID │ Description                                  │'
  printf "%s\n" '  ├─────┼──────────────────────────────────────────────┤'
  printf "%s\n" '  │  1  │ Run - start the script                        │'
  printf "%s\n" '  │  2  │ Compile - save the hello executable           │'
  printf "%s\n" '  │  0  │ Exit                                         │'
  printf "%s\n" '  └─────┴──────────────────────────────────────────────┘'
}

printf "\n  hello — Task Runner\n\n"

while true; do
  show_menu

  printf "  Enter Task ID: "
  read task || exit 0

  if [ "$task" = "0" ]; then
    printf "  Goodbye!\n"
    exit 0
  fi

  if [ "$task" = "1" ]; then
    printf "  hello.lisp\n"
    exec "$SCRIPT_DIR/ask.d/run.sh"
  elif [ "$task" = "2" ]; then
    printf "  hello (executable)\n"
    exec "$SCRIPT_DIR/ask.d/compile.sh"
  else
    printf "  Unknown task: %s\n" "$task"
  fi

  sleep 2
  printf "\n"
done
