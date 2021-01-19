#
# Makefile for UltiConfig
#
# September 2020 ops
#

PROGRAM_BASE = ulticonfig
PROGRAM_SUFFIX = prg
PROGRAM = $(PROGRAM_BASE)
CONFIG = $(PROGRAM_BASE).cfg

ulticonfig_ntsc ?= 0
ifeq ($(ulticonfig_ntsc),1)
  ASFLAGS += -DULTICONFIG_NTSC
  MODEL := ntsc
endif
MODEL ?= pal

AS := ca65
CC := ld65

START_ADDR = 4608

# Additional assembler flags and options.
ASFLAGS += -t vic20 -g
ifeq ($(eload),1)
  ASFLAGS += -DELOAD
endif

# Additional linker flags and options.
LDFLAGS = -C $(CONFIG) -S $(START_ADDR) -Llib

ifeq ($(map),1)
  LDFLAGS += -m $@.map
endif

# Set OBJECTS
OBJECTS := $(PROGRAM_BASE).o

# Set libs
LDLIBS=miniwedge.lib
ifeq ($(eload),1)
  LDLIBS += eload-$(MODEL).lib
else
  LDLIBS += sj20-$(MODEL).lib
endif

.PHONY: clean zip

$(PROGRAM).$(PROGRAM_SUFFIX): $(PROGRAM)
	exomizer sfx $(START_ADDR) -t 20 -o $@ -q $(PROGRAM)

$(PROGRAM): $(OBJECTS)

clean:
	$(RM) $(OBJECTS)
	$(RM) $(PROGRAM).$(PROGRAM_SUFFIX)
	$(RM) $(PROGRAM)
	$(RM) *.zip *.map
	$(RM) *~
