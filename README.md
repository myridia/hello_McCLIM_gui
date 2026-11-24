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

## Windows: native window without X11

The Windows build uses McCLIM 1.0.0's SDL2 backend, so it opens a native window and does not need an X server or `DISPLAY`.

1. Download both `mcclim_windows.exe` and `SDL2.dll` from the same release.
2. Put the two files in the same folder.
3. Run `.\mcclim_windows.exe` from PowerShell or Cmd.

Keep `SDL2.dll` next to the executable (or on `PATH`); Windows uses SDL 2.32.8 x64. The `-nw` flag still works without SDL2. The Windows build first tries Chocolatey for SBCL, then falls back to the official SBCL MSI if the Chocolatey feed is unavailable. The Windows image is saved with `:compression nil` because the Windows SBCL has no zstd support; other platforms use `:compression t`. The saved core cannot retain cl-sdl2's foreign user-event counter, so `main()` allocates a fresh one at startup before opening a port; the reset code lives in `sdl2-runtime.lisp` and is loaded only for SDL2 builds.

## macOS DMG

Releases include `mcclim_macos.dmg` for Apple silicon and `mcclim_macos_intel.dmg` for Intel Macs.

1. Download the DMG for your Mac.
2. Open it and drag `mcclim_macos.app` (Apple silicon) or `mcclim_macos_intel.app` (Intel) to `/Applications`.
3. Eject the disk image.
4. Open McCLIM from `/Applications`.

The SBCL saved executable appends the Lisp image after the Mach-O `__LINKEDIT` segment. Apple requires `__LINKEDIT` to be the last data in a signable Mach-O, so this single-file image cannot be codesigned. The binaries and DMG are therefore unsigned; Gatekeeper may warn on a downloaded copy. A signed/notarized release would need a different layout, such as a signable launcher plus the SBCL runtime and core as separate resources.

If macOS blocks the app, run:

```sh
xattr -dr com.apple.quarantine /Applications/mcclim_macos.app
```

For Intel, use `/Applications/mcclim_macos_intel.app`.

Then use **System Settings → Privacy & Security → Open Anyway** if prompted. For a standalone binary, use `xattr -d com.apple.quarantine ./mcclim_macos` or `./mcclim_macos_intel`.

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

Task 2 creates `dist/mcclim/` with a ~22 MB SBCL executable (plus `SDL2.dll` on Windows). McCLIM, the Lisp runtime, and `DejaVuSans.ttf` are saved into the image, so there is no `lib/` tree and no SBCL, Quicklisp, or system font install needed on the target machine. On each GUI run the embedded font is extracted to `~/.cache/mcclim/DejaVuSans.ttf`; all text styles use that one regular face.

| Project | Distribution | Size |
|---------|--------------|------|
| Racket | `bin/` executable + `lib/` runtime libraries | ~68 MB |
| McCLIM / SBCL | one self-contained executable | ~22 MB |

Copy the executable to another machine with the same OS and CPU architecture and run it there; no companion font file is needed. On Windows, copy `SDL2.dll` with it. The Debian workflow also packages it as `mcclim_0.1.0-1_amd64.deb` via `make_deb/`.

Task 1 installs SBCL when missing, bootstraps Quicklisp into `~/quicklisp`, and loads McCLIM through Quicklisp. On Windows, use a POSIX shell such as Git Bash/MSYS/Cygwin.
