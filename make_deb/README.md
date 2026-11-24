## Debian package

The package installs the prebuilt SBCL executable into `/usr/bin/mcclim`.
McCLIM and `DejaVuSans.ttf` are embedded in that executable.

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
