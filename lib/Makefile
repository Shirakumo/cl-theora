ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS = misc
ARCH = misc
EXT = so
LDFLAGS += -lm
CFLAGS += -O3 -g -fpic -fPIC
INCLUDES = -I$(ROOT_DIR) -I$(ROOT_DIR)/lib -I$(ROOT_DIR)/lib/ogg -I$(ROOT_DIR)/lib/vorbis -I$(ROOT_DIR)/lib/theora

SRC = \
	theorafile.c \
	lib/ogg/bitwise.c \
	lib/ogg/framing.c \
	lib/vorbis/analysis.c \
	lib/vorbis/bitrate.c \
	lib/vorbis/block.c \
	lib/vorbis/codebook.c \
	lib/vorbis/envelope.c \
	lib/vorbis/floor0.c \
	lib/vorbis/floor1.c \
	lib/vorbis/vinfo.c \
	lib/vorbis/lookup.c \
	lib/vorbis/lpc.c \
	lib/vorbis/lsp.c \
	lib/vorbis/mapping0.c \
	lib/vorbis/mdct.c \
	lib/vorbis/psy.c \
	lib/vorbis/registry.c \
	lib/vorbis/res0.c \
	lib/vorbis/sharedbook.c \
	lib/vorbis/smallft.c \
	lib/vorbis/synthesis.c \
	lib/vorbis/window.c \
	lib/theora/apiwrapper.c \
	lib/theora/bitpack.c \
	lib/theora/decapiwrapper.c \
	lib/theora/decinfo.c \
	lib/theora/decode.c \
	lib/theora/dequant.c \
	lib/theora/fragment.c \
	lib/theora/huffdec.c \
	lib/theora/idct.c \
	lib/theora/tinfo.c \
	lib/theora/internal.c \
	lib/theora/quant.c \
	lib/theora/state.c
SRC_X86 = \
	lib/theora/x86/mmxfrag.c \
	lib/theora/x86/mmxidct.c \
	lib/theora/x86/mmxstate.c \
	lib/theora/x86/sse2idct.c \
	lib/theora/x86/x86cpu.c \
	lib/theora/x86/x86state.c
SRC_ARM = \
	lib/theora/arm-intrinsics/armcpu.c \
	lib/theora/arm-intrinsics/armfrag.c \
	lib/theora/arm-intrinsics/armidct.c \
	lib/theora/arm-intrinsics/armloop.c \
	lib/theora/arm-intrinsics/armstate.c

UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
	CFLAGS += -DOC_X86_ASM -DOC_X86_64_ASM
	SRC += $(SRC_X86)
	ARCH = amd64
endif
ifneq ($(filter %86,$(UNAME_M)),)
	CFLAGS += -DOC_X86_ASM
	SRC += $(SRC_X86)
	ARCH = i686
endif
ifneq ($(filter arm%,$(UNAME_M)),)
	CFLAGS += -DOC_ARM_ASM -DOC_ARM_ASM_EDSP -DOC_ARM_ASM_MEDIA -DOC_ARM_ASM_NEON
	SRC += $(SRC_ARM)
	ARCH = arm64
endif

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	CFLAGS += -static-libgcc
	OS = lin
	ifeq ($(ARCH), i686)
		CFLAGS += -include "$(ROOT_DIR)/glibcver/glibc_2.9_x86.h"
	else ifeq ($(ARCH), amd64)
		CFLAGS += -include "$(ROOT_DIR)/glibcver/glibc_2.9_x64.h"
	endif
endif
ifeq ($(UNAME_S),Darwin)
	CFLAGS += -mmacosx-version-min=10.9
	OS = mac
	EXT = dylib
endif
ifneq ($(filter MINGW%,$(UNAME_S)),)
	OS = win
	EXT = dll
endif

all:
	mkdir -p ../static
	$(CC) $(CFLAGS) -shared -o "$(ROOT_DIR)/../static/libtheorafile-$(OS)-$(ARCH).$(EXT)" $(SRC) $(INCLUDES) $(LDFLAGS)

