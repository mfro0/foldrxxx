#include <stdio.h>
#include <stdint.h>
#include <osbind.h>
#include <mint/ostruct.h>
#include <mint/sysvars.h>

int bootdev(void)
{
	uint16_t *bootdev = (uint16_t *) 0x446;

	return *bootdev;
}

int find_num(void)
{
	_DTA *dta;
	char *filename = "C:\\AUTO\\FOLDR???.PRG";
	int num_folders = 0;
	long boot_device;
	long err;

	/*
	 * we want to keep a small footprint, so we use the standard DTA which is set to the basepage of the program on startup
	 */
	dta = Fgetdta();

	boot_device = Supexec(bootdev);

	filename[0] = (unsigned char) boot_device + 'A';

	err = Fsfirst(filename, 0);
	if (err == 0)
	{
		char *num_string = dta->dta_name + 5;
		num_folders = 100 * (num_string[0] - '0') + 10 * (num_string[1] - '0') + num_string[2] - '0';
	}

	return num_folders;
}

char **root_ptr(void)
{
	OSHEADER **sysbase = (OSHEADER **) 0x4f2L;

	return (char **) (*sysbase)->p_root;
}

struct paragraph
{
	int prefix;
	struct paragraph *next;
	uint8_t data[60];
};

void bzero(void *s, size_t n)
{
	int i;

	for (i = 0; i < n; i++)
		* (char *) (s + i) = '\0';
}

void *memset(void *s, int c, size_t n)
{
	int i;

	for (i = 0; i < n; i++)
		* (char *) (s + i) = (char) c;

	return s;
}

void __main(void)
{
	;
}

struct paragraph new_chain[0];

extern uint32_t program_length;

int main(int argc, char *argv[])
{
	int num;
	char **p_root;
	char *old_mem;

	struct paragraph *p = NULL;

	int i;

	(void) Cconws("GCC FOLDRNNN: add GEMDOS folder memory\r\n");

	num = find_num();

	p_root = (char **) Supexec(root_ptr);

	for (i = 0; i < num; i++)
	{
		p = &new_chain[i];

		p->prefix = 0x0004;
		p->next = (struct paragraph *) &new_chain[i + 1].next;
		bzero(p->data, 60);
	}

	old_mem = p_root[4];
	p_root[4] = (char *) &new_chain[0].next;
	p->next = (struct paragraph *) old_mem;

	Ptermres(program_length + num * sizeof(struct paragraph), 0);
	return 0;
}
