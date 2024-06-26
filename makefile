PROJECT_NAME = tri86
SOURCE_PATH = src/
INCLUDE_PATH = include/
OUTPUT_PATH = build

SOURCES = $(wildcard $(SOURCE_PATH)*.c)
OBJECTS = $(patsubst %.c, %.o,$(SOURCES) )

# Compiler config
CC = c:/mspgcc/bin/msp430-gcc
CPU = msp430x247
CFLAGS 	= -mmcu=$(CPU) -O2 -Wall -Wunused -I./$(INCLUDE_PATH)
LDFLAGS = -mmcu=$(CPU) -Wl,-Map=$(OUTPUT_PATH)$*.map

# ALL: Builds all sources and outputs .a43 and .lst file
.PHONY: all
all: $(PROJECT_NAME).deps $(PROJECT_NAME).a43 $(PROJECT_NAME).lst $(PROJECT_NAME).tsf

%.deps:
	mkdir -m a=rwx $(OUTPUT_PATH)
	@echo rm -f $(OUTPUT_PATH)$@
	$(CC) -MM $(CFLAGS) $(SOURCES) > $(OUTPUT_PATH)$@

%.tsf: %.a43
	msp430-encrypt-public.exe $(OUTPUT_PATH)$^ $(OUTPUT_PATH)$@ 0x00001002 4

%.a43: %.elf
	c:/mspgcc/bin/msp430-objcopy -O ihex $(OUTPUT_PATH)$^ $(OUTPUT_PATH)$@

%.lst: %.elf
	c:/mspgcc/bin/msp430-objdump -dSt $(OUTPUT_PATH)$^ > $(OUTPUT_PATH)$@

%.elf: $(OBJECTS)
	$(CC) $(LDFLAGS) -T $*.x -o $(OUTPUT_PATH)$@ $^
	@echo ======================================================
	c:/mspgcc/bin/msp430-size $(OUTPUT_PATH)$@
	@echo ======================================================

# CLEAN: Removes all output and intermediate files 
clean:
	rm -f $(OUTPUT_PATH)*.a43 $(OUTPUT_PATH)*.lst $(OUTPUT_PATH)*.elf $(OUTPUT_PATH)*.map $(OUTPUT_PATH)*.deps $(OBJECTS)


