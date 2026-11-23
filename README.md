<img src="hello_McCLIM_gui.svg" alt="Hello McCLIM GUI logo" width="120">

# hello_McCLIM_gui

Minimal Common Lisp GUI hello-world program built with McCLIM.

The window shows "Hello, world!" with a **Quit** button.

## Run

```sh
sbcl --script main.lisp
```

## No-window mode

```sh
./dist/hello_McCLIM_gui/hello_McCLIM_gui -nw
```

`-nw`, `--nw`, and `--no-window` skip the GUI and print `Hello, world!` to the terminal.
Without a flag, the executable opens the McCLIM window.

## Task Runner

```sh
./ask.sh
```

| ID | Task |
|----|------|
| 1 | Setup - check and install requirements (SBCL, Quicklisp, McCLIM; Linux, macOS, Windows) |
| 2 | Build - save a self-contained SBCL executable |
| 3 | Run - `sbcl --script main.lisp` |
| 0 | Exit |

## Build output

Task 2 creates `dist/hello_McCLIM_gui/` — but unlike Racket's distribution, this directory contains a single file: the ~22 MB SBCL executable. McCLIM and the Lisp runtime are saved into the image, so there is no `lib/` tree and no Quicklisp or SBCL install needed on the target machine.

| Project | Distribution | Size |
|---------|--------------|------|
| Racket | `bin/` executable + `lib/` runtime libraries | ~68 MB |
| McCLIM / SBCL | one self-contained executable | ~22 MB |

Copy `dist/hello_McCLIM_gui/` (or just the executable inside it) to another machine with the same OS and CPU architecture and run it there.

Task 1 installs SBCL when missing, bootstraps Quicklisp into `~/quicklisp`, and loads McCLIM through Quicklisp. On Windows, use a POSIX shell such as Git Bash/MSYS/Cygwin.
