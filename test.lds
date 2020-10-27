SECTIONS
{
	. = 0x90010000;
	.text : {
		src/test.o
		*(.text)
	}
}