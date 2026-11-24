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

Task 2 creates `dist/mcclim/` with a single ~22 MB SBCL executable. McCLIM, the Lisp runtime, and `DejaVuSans.ttf` are saved into the image, so there is no `lib/` tree and no SBCL, Quicklisp, or system font install needed on the target machine. On each GUI run the embedded font is extracted to `~/.cache/mcclim/DejaVuSans.ttf`; all text styles use that one regular face.

| Project | Distribution | Size |
|---------|--------------|------|
| Racket | `bin/` executable + `lib/` runtime libraries | ~68 MB |
| McCLIM / SBCL | one self-contained executable | ~22 MB |

Copy the executable to another machine with the same OS and CPU architecture and run it there; no companion font file is needed.

Task 1 installs SBCL when missing, bootstraps Quicklisp into `~/quicklisp`, and loads McCLIM through Quicklisp. On Windows, use a POSIX shell such as Git Bash/MSYS/Cygwin.
