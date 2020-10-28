test:
    bl clk_init
	bl uart_init
	ldr r0, =0x209C000
	bl uart_pri_r0
	ldr r0, =0x20c8000
	bl uart_pri_r0
	ldr r0, =0x20c400c
	bl uart_pri_r0
1:
	b 1b
	