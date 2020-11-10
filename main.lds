SECTIONS
{
	. = 0x87800000;
	.text : {
		src/main.o
		*(.text)
	}
}