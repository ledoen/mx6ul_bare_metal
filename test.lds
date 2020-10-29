SECTIONS
{
	. = 0x87800000;
	.text : {
		src/test.o
		*(.text)
	}
}
