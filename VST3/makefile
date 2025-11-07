# chugin name
CHUGIN_NAME=VST3

# all of the c/cpp files that compose this chugin
C_MODULES=
CXX_MODULES=VST3.cpp

# where to find chugin.h
CK_SRC_PATH?=../chuck/include/

# VST3 SDK path - can be overridden via environment variable
VST3_SDK_PATH?=$(PWD)/VST_SDK/vst3sdk

# ---------------------------------------------------------------------------- #
# you won't generally need to change anything below this line for a new chugin #
# ---------------------------------------------------------------------------- #

# default target: print usage message and quit
current:
	@echo "[chugin build]: please use one of the following configurations:"
	@echo "   make linux, make mac, make web, or make win32"

ifneq ($(CK_TARGET),)
.DEFAULT_GOAL:=$(CK_TARGET)
ifeq ($(MAKECMDGOALS),)
MAKECMDGOALS:=$(.DEFAULT_GOAL)
endif
endif

.PHONY: mac osx linux linux-oss linux-jack linux-alsa win32 demo
mac osx linux linux-oss linux-jack linux-alsa: all

win32:
	make -f makefile.win

CC=gcc
CXX=gcc
LD=g++

CHUGIN_PATH=/usr/local/lib/chuck

ifneq (,$(strip $(filter mac osx bin-dist-osx,$(MAKECMDGOALS))))
include makefile.mac
endif

ifneq (,$(strip $(filter linux,$(MAKECMDGOALS))))
include makefile.linux
endif

ifneq (,$(strip $(filter linux-oss,$(MAKECMDGOALS))))
include makefile.linux
endif

ifneq (,$(strip $(filter linux-jack,$(MAKECMDGOALS))))
include makefile.linux
endif

ifneq (,$(strip $(filter linux-alsa,$(MAKECMDGOALS))))
include makefile.linux
endif

# Check if VST3 SDK is available
ifneq ("$(wildcard $(VST3_SDK_PATH))","")
FLAGS+= -DHAVE_VST3_SDK -I$(VST3_SDK_PATH)
# Define VST3 SDK source files to compile on macOS
ifeq ($(findstring mac,$(MAKECMDGOALS)),mac)
# Platform-specific module loader and thread checker
VST3_SDK_MM_MODULES=$(VST3_SDK_PATH)/public.sdk/source/vst/hosting/module_mac.mm \
                    $(VST3_SDK_PATH)/public.sdk/source/common/threadchecker_mac.mm
VST3_SDK_MM_OBJECTS=$(VST3_SDK_MM_MODULES:.mm=.mm.o)

# Core hosting library sources
VST3_SDK_CPP_MODULES=$(VST3_SDK_PATH)/public.sdk/source/vst/hosting/module.cpp \
                     $(VST3_SDK_PATH)/public.sdk/source/vst/hosting/plugprovider.cpp \
                     $(VST3_SDK_PATH)/public.sdk/source/vst/hosting/hostclasses.cpp \
                     $(VST3_SDK_PATH)/public.sdk/source/vst/hosting/connectionproxy.cpp \
                     $(VST3_SDK_PATH)/public.sdk/source/vst/hosting/pluginterfacesupport.cpp \
                     $(VST3_SDK_PATH)/public.sdk/source/vst/vstinitiids.cpp \
                     $(VST3_SDK_PATH)/public.sdk/source/vst/utility/stringconvert.cpp \
                     $(VST3_SDK_PATH)/public.sdk/source/common/commonstringconvert.cpp
VST3_SDK_CPP_OBJECTS=$(addsuffix .o,$(basename $(VST3_SDK_CPP_MODULES)))

# Base library sources
VST3_SDK_BASE_MODULES=$(VST3_SDK_PATH)/base/source/fstring.cpp \
                      $(VST3_SDK_PATH)/base/source/baseiids.cpp \
                      $(VST3_SDK_PATH)/base/source/fdebug.cpp \
                      $(VST3_SDK_PATH)/base/source/fobject.cpp \
                      $(VST3_SDK_PATH)/base/thread/source/flock.cpp
VST3_SDK_BASE_OBJECTS=$(addsuffix .o,$(basename $(VST3_SDK_BASE_MODULES)))

# Pluginterfaces library sources
VST3_SDK_PLUG_MODULES=$(VST3_SDK_PATH)/pluginterfaces/base/coreiids.cpp \
                      $(VST3_SDK_PATH)/pluginterfaces/base/funknown.cpp \
                      $(VST3_SDK_PATH)/pluginterfaces/base/conststringtable.cpp \
                      $(VST3_SDK_PATH)/pluginterfaces/base/ustring.cpp
VST3_SDK_PLUG_OBJECTS=$(addsuffix .o,$(basename $(VST3_SDK_PLUG_MODULES)))

VST3_SDK_OBJECTS=$(VST3_SDK_MM_OBJECTS) $(VST3_SDK_CPP_OBJECTS) $(VST3_SDK_BASE_OBJECTS) $(VST3_SDK_PLUG_OBJECTS)
endif
else
$(warning VST3 SDK not found at $(VST3_SDK_PATH). Building stub version.)
$(warning To build with VST3 support, install the VST3 SDK and set VST3_SDK_PATH)
endif

ifneq ($(CHUCK_DEBUG),)
FLAGS+= -g
else
FLAGS+= -O3
endif

ifneq ($(CHUCK_STRICT),)
FLAGS+= -Werror
endif

# default: build a dynamic chugin
CK_CHUGIN_STATIC?=0

ifeq ($(CK_CHUGIN_STATIC),0)
SUFFIX=.chug
else
SUFFIX=.schug
FLAGS+= -D__CK_DLL_STATIC__
endif
# webchugin extension
WEBSUFFIX=.wasm

C_OBJECTS=$(addsuffix .o,$(basename $(C_MODULES)))
CXX_OBJECTS=$(addsuffix .o,$(basename $(CXX_MODULES)))

CHUG=$(addsuffix $(SUFFIX),$(CHUGIN_NAME))
WEBCHUG=$(addsuffix $(WEBSUFFIX),$(CHUG))

all: $(CHUG)

$(CHUG): $(C_OBJECTS) $(CXX_OBJECTS) $(VST3_SDK_OBJECTS)
ifeq ($(CK_CHUGIN_STATIC),0)
	$(LD) $(LDFLAGS) -o $@ $^
else
	ar rv $@ $^
	ranlib $@
endif

# Compile VST3 SDK Objective-C++ sources (.mm files)
%.mm.o: %.mm
	$(CXX) $(FLAGS) -fobjc-arc -c -o $@ $<

# Compile VST3 SDK C++ sources
$(VST3_SDK_CPP_OBJECTS) $(VST3_SDK_BASE_OBJECTS) $(VST3_SDK_PLUG_OBJECTS): %.o: %.cpp
	$(CXX) $(FLAGS) -c -o $@ $<

$(C_OBJECTS): %.o: %.c
	$(CC) $(FLAGS) -c -o $@ $<

$(CXX_OBJECTS): %.o: %.cpp $(CK_SRC_PATH)/chugin.h
	$(CXX) $(FLAGS) -c -o $@ $<

# build as webchugin
web:
	emcc -O3 -s SIDE_MODULE=1 -s DISABLE_EXCEPTION_CATCHING=0 -fPIC -Wformat=0 \
	-I ../chuck/include/ $(CXX_MODULES) $(C_MODULES) -o $(WEBCHUG)

install: $(CHUG)
	mkdir -p $(CHUGIN_PATH)
	cp $^ $(CHUGIN_PATH)
	chmod 755 $(CHUGIN_PATH)/$(CHUG)

clean:
	rm -rf $(C_OBJECTS) $(CXX_OBJECTS) $(VST3_SDK_OBJECTS) $(CHUG) $(WEBCHUG) Release Debug
