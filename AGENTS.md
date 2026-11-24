# AGENTS.md — hello_McCLIM_gui

## What this is
Minimal Common Lisp GUI hello-world program built with McCLIM (a Common Lisp implementation of CLIM).

The window shows “Hello, world!” with a **Quit** button.

## Stack
- Common Lisp (SBCL)
- McCLIM
- Quicklisp

## Structure
- `main.lisp` — GUI entry point; loads Quicklisp/McCLIM, defines the application frame, and runs it
- `ask.sh` — task runner menu
- `ask.d/lib.sh` — shared task helpers
- `ask.d/setup.sh` — task 1: check/install SBCL, bootstrap Quicklisp, load McCLIM
- `ask.d/build.sh` — task 2: save a self-contained SBCL executable
- `ask.d/run.sh` — task 3: run with `sbcl --script main.lisp`
- `README.md` — project title, logo, and commands
- `AGENTS.md` — this project guide
- `LICENSE` — project license
- `.gitignore` — Common Lisp and build-output ignore rules
- `hello_McCLIM_gui.svg` — README logo; also used by the project page
- `pages/public/` — GitHub Pages site (`index.html`, `style.css`, `img/hello_McCLIM_gui.svg`), deployed by `pages.yml`

## Run
```sh
./ask.sh
```

Task 1 checks for `sbcl`, a downloader (`curl`/`wget`), and Quicklisp, installs SBCL when missing (`apt-get`, `dnf`, or `pacman` on Linux; Homebrew on macOS; Chocolatey, Scoop, or winget under a POSIX shell on Windows), bootstraps Quicklisp into `~/quicklisp`, and loads McCLIM. Task 2 uses `sb-ext:save-lisp-and-die` to build a self-contained executable in `bin/` and copies it to `dist/hello_McCLIM_gui/`. Task 3 runs `main.lisp` directly.

Direct command:
```sh
sbcl --script main.lisp
```

Built executable with no window:
```sh
./dist/hello_McCLIM_gui/hello_McCLIM_gui -nw
```

`-nw`, `--nw`, and `--no-window` print `Hello, world!` to stdout instead of opening the McCLIM window.

## Workflows
- `.github/workflows/control.yml` — single build gate copied from couchy; push to `main`, any tag, and manual dispatch. `linux` and `pages` are enabled; the other build lines are commented out.
- `.github/workflows/linux.yml` — `workflow_call` + `workflow_dispatch`. Install step installs SBCL/curl and bootstraps Quicklisp with McCLIM, then builds via `ask.d/build.sh`, smoke-tests the `-nw` output, and uploads `hello_McCLIM_gui_linux` to the release. It deliberately omits `ql:add-to-init-file` — that call prompts for Enter and fails on CI's closed stdin; `main.lisp` loads `~/quicklisp/setup.lisp` itself.
- `.github/workflows/pages.yml` — `workflow_call` + `workflow_dispatch`, deploys `pages/public` to GitHub Pages via `configure-pages` / `upload-pages-artifact` / `deploy-pages`. The `myridia` guard lives only in `control.yml`.

## Conventions
- Keep the README logo as its first line.
- No code comments unless asked.
- Do not compile or run Lisp code; the user builds and runs it.
- Apply workspace permissions after edits: `chown -R 1000:33 <project>` and `chmod -R g+w <project>`.
