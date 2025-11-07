
CHUGINS=AbletonLink AudioUnit CLAP VST3

CHUGS_NOT_ON_WIN32=AudioUnit
CHUGINS_WIN32=$(filter-out $(CHUGS_NOT_ON_WIN32),$(CHUGINS))

CHUGS=$(foreach CHUG,$(CHUGINS),$(CHUG)/$(CHUG).chug)
WEBCHUGS=$(foreach CHUG,$(CHUGINS),$(CHUG)/$(CHUG).chug.wasm)
CHUGS_WIN32=$(foreach CHUG,$(CHUGINS_WIN32),$(CHUG)/$(CHUG).chug)
CHUGS_RELEASE=$(foreach CHUG,$(CHUGINS_WIN32),$(CHUG)/Release/$(CHUG).chug)
CHUGS_CLEAN=$(addsuffix .clean,$(CHUGINS))

DESTDIR?=/usr/local
INSTALL_DIR=$(DESTDIR)/lib/chuck
INSTALL_DIR_WIN32="C:/Program Files/ChucK/chugins"

# default target: print usage message and quit
current: 
	@echo "[chugins build]: please use one of the following configurations:"
	@echo "   make linux, make mac, make web, or make win32"

ifneq ($(CK_TARGET),)
.DEFAULT_GOAL:=$(CK_TARGET)
ifeq ($(MAKECMDGOALS),)
MAKECMDGOALS:=$(.DEFAULT_GOAL)
endif
endif

CHUCK_STRICT=1

mac: $(CHUGS)
osx: $(CHUGS)
linux: $(CHUGS)
linux-alsa: $(CHUGS)
linux-jack: $(CHUGS)
web: $(WEBCHUGS)
win32: $(CHUGS_WIN32)

$(CHUGS):
	CHUCK_STRICT=1 make -C $(dir $@) $(MAKECMDGOALS)

$(WEBCHUGS):
	CHUCK_STRICT=1 make -C $(dir $@) $(MAKECMDGOALS)

clean: $(CHUGS_CLEAN)
.PHONY: $(CHUGS_CLEAN)
$(CHUGS_CLEAN):
	make -C $(basename $@) clean

#.PHONY: $(CHUGS_WIN32)
#$(CHUGS_WIN32):
#	cd $(basename $@); msbuild.exe /p:Configuration=Release

install: $(CHUGS)
	mkdir -p $(INSTALL_DIR)
	cp -rf $(CHUGS) $(INSTALL_DIR)

install-win32: $(CHUGS_RELEASE)
	mkdir -p $(INSTALL_DIR_WIN32)
	cp -rf $(CHUGS_RELEASE) $(INSTALL_DIR_WIN32)

DATE=$(shell date +"%Y-%m-%d")

