# AGENTS.md — mcclim

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
- `ask.d/build.sh` — task 2: embed `DejaVuSans.ttf` in the SBCL image and save a self-contained executable
- `ask.d/run.sh` — task 3: run with `sbcl --script main.lisp`
- `README.md` — project title, logo, and commands
- `AGENTS.md` — this project guide
- `LICENSE` — project license
- `make_deb/` — Debian packaging (`dpkg-buildpackage`) for the prebuilt executable; `make_deb/src/mcclim` is copied in by the Debian workflow
- `.gitignore` — Common Lisp and build-output ignore rules
- `mcclim.svg` — README logo; also used by the project page
- `pages/public/` — GitHub Pages site (`index.html`, `style.css`, `img/mcclim.svg`), deployed by `pages.yml`

## Run
```sh
./ask.sh
```

Task 1 checks for `sbcl`, a downloader (`curl`/`wget`), and Quicklisp, installs SBCL when missing (`apt-get`, `dnf`, or `pacman` on Linux; Homebrew on macOS; Chocolatey, Scoop, or winget under a POSIX shell on Windows), bootstraps Quicklisp into `~/quicklisp`, and loads McCLIM. Task 2 reads `DejaVuSans.ttf` into a byte vector at build time, saves that vector with the executable via `sb-ext:save-lisp-and-die` in `bin/`, and copies the executable to `dist/mcclim/`. `main.lisp` writes the embedded bytes to `~/.cache/mcclim/DejaVuSans.ttf` and repoints `*families/faces*` there, so the target machine needs no font file. Task 3 runs `main.lisp` directly.

Direct command:
```sh
sbcl --script main.lisp
```

Built executable with no window:
```sh
./dist/mcclim/mcclim -nw
```

`-nw`, `--nw`, and `--no-window` print `Hello, world!` to stdout instead of opening the McCLIM window.

## Workflows
- `.github/workflows/control.yml` — single build gate copied from couchy; push to `main`, any tag, and manual dispatch. `linux`, `debian`, `windows`, `macos`, `macos_intel`, and `freebsd` are enabled; `msix` and `pages` are commented out.
- `.github/workflows/linux.yml` — `workflow_call` + `workflow_dispatch`. Install step installs SBCL/curl and bootstraps Quicklisp with McCLIM, then builds inline, smoke-tests the `-nw` output, uploads the single `mcclim_linux` binary to the release with `DejaVuSans.ttf` embedded in the image. It deliberately omits `ql:add-to-init-file` — that call prompts for Enter and fails on CI's closed stdin; `main.lisp` loads `~/quicklisp/setup.lisp` itself. `ask.d/setup.sh` writes the same init block to `~/.sbclrc` itself instead of calling the prompt.
- `.github/workflows/debian.yml` — `workflow_call` + `workflow_dispatch`. Builds the executable, copies it into `make_deb/src/`, runs `dpkg-buildpackage -us -uc -b`, and uploads `mcclim_0.1.0-1_amd64.deb`.
- `.github/workflows/macos.yml` — `workflow_call` + `workflow_dispatch`. Builds on `macos-15`, uploads `mcclim_macos`.
- `.github/workflows/macos_intel.yml` — `workflow_call` + `workflow_dispatch`. Builds on `macos-15-intel`, uploads `mcclim_macos_intel`.
- `.github/workflows/windows.yml` — `workflow_call` + `workflow_dispatch`. Installs SBCL with Chocolatey, builds in Git Bash, uploads `mcclim_windows.exe`.
- `.github/workflows/freebsd.yml` — `workflow_call` + `workflow_dispatch`. Builds in a FreeBSD VM, uploads `mcclim_freebsd`.
- `.github/workflows/pages.yml` — `workflow_call` + `workflow_dispatch`, deploys `pages/public` to GitHub Pages via `configure-pages` / `upload-pages-artifact` / `deploy-pages`. The `myridia` guard lives only in `control.yml`.

## Conventions
- Keep the README logo as its first line.
- No code comments unless asked.
- Do not compile or run Lisp code; the user builds and runs it.
- Apply workspace permissions after edits: `chown -R 1000:33 <project>` and `chmod -R g+w <project>`.
