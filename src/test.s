test:
	bl clk_init
	bl uart_init
	bl led_init
	
	ldr r0, =0x209C000
	bl uart_pri_r0
	bl uart_newline
	
	ldr r0, =0x20c8000
	bl uart_pri_r0
	bl uart_newline

	
	ldr r0, =0x20200b4
	bl uart_pri_r0
	bl uart_newline
	
	bl led_up
1:
	b 1b
	