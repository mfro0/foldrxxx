# 

TOOLCHAIN_PREFIX=m68k-atari-mint-
CC=$(TOOLCHAIN_PREFIX)gcc

UNAME := $(shell uname)
ifeq ($(UNAME),Linux)
PREFIX=m68k-atari-mint
HATARI=hatari
else
PREFIX=/opt/cross-mint/m68k-atari-mint
HATARI=/usr/local/bin/hatari
endif

CFLAGS= \
	-Os\
	-fomit-frame-pointer \
	-Wall\
	-mcpu=547x \
	-nostdlib
	
FOLDRXXX=foldrxxx
APP=$(FOLDRXXX).prg
CFAPP=$(FOLDRXCF).prg

all: $(APP)

SOURCES=startup.S $(FOLDRXXX).c
		
OBJECTS=$(SOURCES:.c=.o)

$(APP): $(OBJECTS) depend
	$(CC) $(CFLAGS) $(OBJECTS) -o $(APP)
	m68k-atari-mint-strip $(APP)
		
.PHONY clean:
	- rm -rf *.o depend foldrxxx.prg

depend: $(SOURCES)
		$(CC) $(CFLAGS) $(INCLUDE) -M $(SOURCES) foldrxxx.c > depend

release: foldrxxx.prg
	tar cvf foldrxxx.tar.gz foldrxxx.prg

	
ifneq (clean,$(MAKECMDGOALS))
-include depend
endif
