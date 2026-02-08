# my-chugins

A collection of chugins (plugins) for the [ChucK](https://chuck.stanford.edu/) audio programming language.

| Chugin | Description |
|--------|-------------|
| **AbletonLink** | Tempo sync via the Ableton Link protocol |
| **AudioUnit** | Load and use macOS AudioUnit plugins (macOS only) |
| **CLAP** | Load and use CLAP (CLever Audio Plugin) plugins |
| **PdPatch** | Embed Pure Data patches as ChucK UGens |
| **VST3** | Load and use VST3 plugins |

## Building

There are two build systems: **CMake** (recommended) and **legacy Make**.

### CMake (recommended)

Requires CMake 3.19+ and a network connection (dependencies are fetched automatically via FetchContent).

```bash
make                  # Build all chugins
make AbletonLink      # Build a single chugin
make CLAP VST3        # Build specific chugins
make clean            # Remove build directory
make install          # Build and install all chugins
make help             # Show all targets and options
```

Options:

```bash
make BUILD_TYPE=Debug           # Debug build (default: Release)
make DESTDIR=/opt/chuck         # Custom install prefix (default: /usr/local)
make JOBS=4                     # Parallel jobs (default: cpu count)
make CMAKE_FLAGS="-DFOO=bar"    # Extra CMake flags
```

### Legacy Make

Uses vendored dependencies checked into the repo. No network connection required.

```bash
make legacy-mac       # macOS
make legacy-linux     # Linux
make legacy-win32     # Windows
```

## Dependencies and build systems

External dependencies are handled differently by each build system:

| Chugin | CMake (FetchContent) | Legacy Make (vendored) |
|--------|----------------------|------------------------|
| AbletonLink | Fetched from [Ableton/link](https://github.com/Ableton/link) (Link-3.1.5) | `AbletonLink/link/` |
| CLAP | Fetched from [free-audio/clap](https://github.com/free-audio/clap) (1.2.6) | `CLAP/clap-headers/` |
| PdPatch | Fetched from [libpd/libpd](https://github.com/libpd/libpd) | CMake only |
| VST3 | Fetched from [steinbergmedia/vst3sdk](https://github.com/steinbergmedia/vst3sdk) (v3.8.0) | Manual SDK install or `VST3/setup.sh` |
| AudioUnit | System frameworks (no external deps) | Same |

The vendored directories (`AbletonLink/link/`, `CLAP/clap-headers/`) are kept in the repo for the legacy Make build. The CMake build ignores them entirely and downloads its own copies into `build/_deps/`.
