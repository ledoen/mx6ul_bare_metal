SECTIONS
{
	. = 0x87800000;
	.text : {
		src/startup.o
		*(.text)
	}
}