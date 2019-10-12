# foldrxxx
a minimal reimplementation of Atari's FOLDRXXX.PRG in C

GEMDOS has fixed size memory pools that easily overflow with large amount of memory and lots of dynamic memory allocations (most notable with harddisks and deep folder structures that exceed the amount of memory TOS designers originally thought adequate for floppy-based systems). Atari fixed that with an AUTO folder program that extends this memory pool by adding additional memory to the pool with a Ptermres() TSR program.

As this patch program is only available as m68k binary (and does not run on native ColdFire), here is a simple reimplementation in C that should work on any TOS platform if compiled accordingly. The program is supposed to go in your AUTO folder and needs to be renamed to 'FOLDRxxx.PRG' where 'xxx' is the numeric value of the number of additional folders you want GEMDOS be able to handle.

Note that this program follows a minimal approach and does not do error checking. If you e.g. start it from the desktop without a renamed version in your AUTO folder or failed to rename it properly, it will most likely crash.

This program is also suitable for EmuTOS that (for compatibility reasons) suffers from the same limitations than original TOS.


