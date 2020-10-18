#
# Makefile for UltiConfig
#
# September 2020 ops
#

PROGRAM_BASE = ulticonfig
PROGRAM_SUFFIX = prg
PROGRAM := $(PROGRAM_BASE)

MODEL ?= pal
CONFIG = $(PROGRAM_BASE).cfg

AS := ca65
CC := ld65

START_ADDR = 4608

# Additional assembler flags and options.
ASFLAGS += -t vic20 -g

# Additional linker flags and options.
LDFLAGS = -C $(CONFIG) -S $(START_ADDR) -Llib

# Set OBJECTS
OBJECTS := $(PROGRAM_BASE).o

# Set libs
LDLIBS=miniwedge.lib sj20-$(MODEL).lib

.PHONY: clean zip

$(PROGRAM).$(PROGRAM_SUFFIX): $(PROGRAM)
	exomizer sfx $(START_ADDR) -t 20 -o $@ -q $(PROGRAM)

$(PROGRAM): $(OBJECTS)

zip:
	zip ulticonfig-v1.1-$(MODEL).zip ulticonfig.prg

clean:
	$(RM) $(OBJECTS)
	$(RM) $(PROGRAM).$(PROGRAM_SUFFIX)
	$(RM) $(PROGRAM)
	$(RM) *.zip
	$(RM) *~
