<img src="mcclim.svg" alt="McCLIM GUI logo" width="120">

# mcclim

Minimal Common Lisp GUI hello-world program built with McCLIM.

The window shows "Hello, world!" with a **Quit** button.

## Run

```sh
sbcl --script main.lisp
```

## No-window mode

```sh
./dist/mcclim/mcclim -nw
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

Task 2 creates `dist/mcclim/` with the ~22 MB SBCL executable and `DejaVuSans.ttf`. McCLIM and the Lisp runtime are saved into the image, so there is no `lib/` tree and no Quicklisp or SBCL install needed on the target machine. The font sits next to the executable, so the GUI renders without relying on system fonts; all text styles use that one regular face.

| Project | Distribution | Size |
|---------|--------------|------|
| Racket | `bin/` executable + `lib/` runtime libraries | ~68 MB |
| McCLIM / SBCL | executable + one TTF font | ~22 MB |

Copy `dist/mcclim/` to another machine with the same OS and CPU architecture and run the executable from that directory.

Task 1 installs SBCL when missing, bootstraps Quicklisp into `~/quicklisp`, and loads McCLIM through Quicklisp. On Windows, use a POSIX shell such as Git Bash/MSYS/Cygwin.
