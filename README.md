<img src="hello_McCLIM_gui.svg" alt="Hello McCLIM GUI logo" width="120">

# hello_McCLIM_gui

Minimal Common Lisp GUI hello-world program built with McCLIM.

The window shows "Hello, world!" with a **Quit** button.

## Run

```sh
sbcl --script main.lisp
```

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

Task 2 creates `dist/hello_McCLIM_gui/` with the executable. The SBCL executable is self-contained — McCLIM and the runtime are saved into the image, so no library directory is needed. Copy the executable to another machine with the same OS and CPU architecture.

Task 1 installs SBCL when missing, bootstraps Quicklisp into `~/quicklisp`, and loads McCLIM through Quicklisp. On Windows, use a POSIX shell such as Git Bash/MSYS/Cygwin.
