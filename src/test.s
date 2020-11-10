test:
	bl clk_init
	bl uart_init
	bl led_init
	
	
	ldr r0, =0x21c8000
	bl uart_pri_r0
	bl uart_newline
	
	ldr r0, =0x21c8010
	bl uart_pri_r0
	bl uart_newline
	
	ldr r0, =0x21c81b0
	bl uart_pri_r0
	bl uart_newline	
	
	ldr r0, =0x00ff0000
	bl write_rgb_data
	
	bl lcd_init

	ldr r0, =0x21c8000
	bl uart_pri_r0
	bl uart_newline
	
	ldr r0, =0x21c8010
	bl uart_pri_r0
	bl uart_newline

	
	ldr r0, =0x21c81b0
	bl uart_pri_r0
	bl uart_newline
	
	bl uart_newline
	
	bl led_up
1:
	b 1b
	