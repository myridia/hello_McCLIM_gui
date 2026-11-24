## Debian package

The package installs the prebuilt SBCL executable into `/usr/bin/mcclim`.
McCLIM and `DejaVuSans.ttf` are embedded in that executable.

## How it works

The `.deb` is only a wrapper around the compiled binary. `dpkg-buildpackage`
does not compile Lisp; it stages the executable in a fake root and compresses
that tree into the package.

### Flow

```text
main.lisp + SBCL + Quicklisp/McCLIM
        ↓  CI "Compile" step
dist/mcclim/mcclim              (~23 MB, font/core embedded)
        ↓  cp
make_deb/src/mcclim
        ↓  dpkg-buildpackage -us -uc -b
make_deb/src/debian/mcclim/     (staging root)
        ↓
make_deb/mcclim_0.1.0-1_amd64.deb
```

### Packaging files

| File | Role |
| --- | --- |
| `debian/control` | Package name, architecture, maintainer, description, dependency placeholders. |
| `debian/changelog` | Version `0.1.0-1`, which becomes the `.deb` filename. |
| `debian/source/format` | `3.0 (native)` — no separate upstream tarball. |
| `debian/copyright` | License metadata shipped in the package. |
| `debian/install` | Maps `mcclim` to `usr/bin/` in the staging root. |
| `debian/rules` | Debhelper build script. Skips compilation, installs the binary, disables stripping. |

### `debian/rules`

`dh $@` runs the debhelper sequence: configure → build → test → install →
strip → shlibdeps → control → builddeb.

```make
%:
	dh $@

override_dh_auto_configure:
override_dh_auto_build:
override_dh_auto_test:

override_dh_auto_install:
	install -D -m 755 mcclim debian/mcclim/usr/bin/mcclim

override_dh_strip:
```

The empty overrides stop debhelper from trying to configure, build, or test a
project that is already built. `install -D ...` stages the executable into
`debian/mcclim/usr/bin/mcclim`; that directory becomes the installed filesystem.

`override_dh_strip:` is a no-op. Debhelper normally runs `strip`, but that
removes the SBCL core embedded in the executable: 23 MB becomes about
450 KB and the result will not run.

`debian/install` and `override_dh_auto_install` currently install the same file
twice. That is harmless, but one of them would be enough.

### What ends up in the package

```text
/usr/bin/mcclim
/usr/share/doc/mcclim/copyright
/DEBIAN/control
/DEBIAN/md5sums
```

`${shlibs:Depends}` and `${misc:Depends}` in `debian/control` are substituted
during the build by `dh_shlibdeps` and `dh_gencontrol`.

### Workflow verification

After `dpkg-buildpackage`, the workflow lists and extracts the package:

```sh
dpkg-deb -c "$deb"
dpkg-deb -x "$deb" /tmp/mcclim-deb-check
stat -c%s /tmp/mcclim-deb-check/usr/bin/mcclim
```

If the packaged executable is under 10 MB, the job fails. That catches the
stripping regression before release.

## Copy the built binary

```
cp ../../dist/mcclim/mcclim src/mcclim
```

## Build the package

```
cd src
dpkg-buildpackage -us -uc -b
```

The `.deb` lands in `make_deb/`.

## Install with apt (pulls in dependencies)

```
apt install ./mcclim_0.1.0-1_amd64.deb
```

## Install with dpkg

```
sudo dpkg -i mcclim_0.1.0-1_amd64.deb
```

## Review installed files

```
dpkg -L mcclim
```

## Remove

```
sudo apt-get remove mcclim --purge
```
