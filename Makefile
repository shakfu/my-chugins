# CMake frontend Makefile
#
# Usage:
#   make                  Build all chugins
#   make AbletonLink      Build only AbletonLink
#   make CLAP VST3        Build CLAP and VST3
#   make clean            Remove build directory
#   make install          Install chugins
#   make configure        Run CMake configure only
#   make legacy-mac       Build via legacy Makefile (make mac)
#
# Options:
#   BUILD_DIR=<path>      Build directory (default: build)
#   BUILD_TYPE=<type>     CMake build type (default: Release)
#   CMAKE_FLAGS=<flags>   Extra flags passed to cmake configure
#   DESTDIR=<path>        Install prefix (default: /usr/local)
#   JOBS=<n>              Parallel jobs (default: system cpu count)

BUILD_DIR   ?= build
BUILD_TYPE  ?= Release
CMAKE_FLAGS ?=
DESTDIR     ?= /usr/local
JOBS        ?= $(shell sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)

CHUGINS := AbletonLink CLAP PdPatch VST3

.PHONY: all $(CHUGINS) configure clean install help legacy-%

all: $(CHUGINS)

$(BUILD_DIR)/CMakeCache.txt:
	cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-DCMAKE_INSTALL_PREFIX=$(DESTDIR) $(CMAKE_FLAGS)

configure: $(BUILD_DIR)/CMakeCache.txt

$(CHUGINS): $(BUILD_DIR)/CMakeCache.txt
	cmake --build $(BUILD_DIR) --target $@ -j$(JOBS)

clean:
	$(RM) -r $(BUILD_DIR)

install: all
	cmake --install $(BUILD_DIR)

legacy-%:
	$(MAKE) -f Makefile.legacy $*

help:
	@echo "Targets:"
	@echo "  all (default)     Build all chugins"
	@echo "  AbletonLink       Build AbletonLink chugin"
	@echo "  CLAP              Build CLAP chugin"
	@echo "  PdPatch           Build PdPatch chugin"
	@echo "  VST3              Build VST3 chugin"
	@echo "  configure         Run CMake configure step only"
	@echo "  clean             Remove build directory"
	@echo "  install           Build and install all chugins"
	@echo "  legacy-<target>   Delegate to Makefile.legacy (e.g. legacy-mac)"
	@echo "  help              Show this message"
	@echo ""
	@echo "Options:"
	@echo "  BUILD_DIR=<path>   (default: build)"
	@echo "  BUILD_TYPE=<type>  (default: Release)"
	@echo "  DESTDIR=<path>     (default: /usr/local)"
	@echo "  JOBS=<n>           (default: cpu count)"
	@echo "  CMAKE_FLAGS=<f>    Extra cmake flags"
