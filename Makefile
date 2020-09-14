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
LD := ld65

START_ADDR = 4608

# Additional assembler flags and options.
ASFLAGS += -t vic20 -g

# Additional linker flags and options.
LDFLAGS = -C $(CONFIG) -Llib

# Set OBJECTS
OBJECTS :=  $(PROGRAM_BASE).o

# Set libs
LIBRARY=miniwedge.lib sj20-$(MODEL).lib

.PHONY: clean

$(PROGRAM).$(PROGRAM_SUFFIX): $(PROGRAM)
	exomizer sfx 4608 -t 20 -o $@ -q $(PROGRAM)

$(PROGRAM): $(CONFIG) $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ -S $(START_ADDR) $(OBJECTS) $(LIBRARY)

clean:
	$(RM) $(OBJECTS)
	$(RM) $(PROGRAM).$(PROGRAM_SUFFIX)
	$(RM) $(PROGRAM)
	$(RM) *~
