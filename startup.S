		.extern	_main
		.globl 	_program_length

 		.equ 	BASEPAGE_SIZE,0x100
		
		.text

start:
		move.l	4(sp),a5					| address to basepage
		move.l	0x0c(a5),d0					| length of text segment
		add.l	0x14(a5),d0					| length of data segment
		add.l	0x1c(a5),d0					| length of bss segment
		add.l	#BASEPAGE_SIZE,d0			| length of stackpointer+basepage
		move.l	d0,_program_length			| save program length so _main() can access it
	
		jsr	_main							| make sure we never return here

		.bss
		
_program_length:
		ds.l	1

