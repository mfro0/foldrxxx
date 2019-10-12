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
	-mshort\
	-nostdlib
	
FOLDRXXX=foldrxxx
APP=$(FOLDRXXX).prg

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

test: foldrxxx.prg
	$(HATARI) -D --tos ../emutos/etos512k.img -m --bios-intercept --cpuclock 32 --machine ste --cpulevel 3 --vdi true --vdi-planes 1 \
	--vdi-width 800 --vdi-height 600 -d .



	
ifneq (clean,$(MAKECMDGOALS))
-include depend
endif
