.global led_init

led_init:
	
	@enable GPIO clk
	ldr r0, =0x20c406c	@将CCM_CCGR1寄存器的地址放入r0
	ldr r1, [r0]		@将CCM_CCGR1寄存器的值读出放r1
	ldr r2, =0x3		
	lsl r2, r2, #26		@产生一个第26、27位为1的值放入r2
	orr r1, r1, r2		@将r1值的26、27位置为1
	str r1, [r0]		@将r1的值放入CCM_CCGR1寄存器
	
	@set IOMUX Register
	ldr r0, =0x020e0080		@将IOMUX寄存器地址放入r0
	ldr r1, [r0]		@将寄存器值读出放入r1
	bic r1, r1, #0xf		@将r1的低4位清零
	orr r1, #0x5			@将r1的低4位置为0101b
	str r1, [r0]		@将r1的值放回IOMUX寄存器
	
	@set GPIO_PAD Register
	ldr r0, =0x020e030c
	ldr r1, [r0]
	ldr r2, =0xffff
	bic r1, r1, r2
	ldr r2, =0x10b0
	orr r1, r1, r2
	str r1, [r0]
	
	@set GPIO_DIR Register
	ldr r0, =0x0209c004
	ldr r1, [r0]
	ldr r2, =0x1
	lsl r2, #9
	orr r1, r1, r2
	str r1, [r0]
	@set GPIO_DAT Register
	ldr r0, =0x0209c000
	ldr r1, [r0]
	ldr r2, =0x1
	lsl r2, #9
	bic r1, r1, r2
	str r1, [r0]
	

    mov pc, lr
    
.global led_up

led_up:
    @light led
	ldr r0, =0x0209c000
	ldr r1, [r0]
	ldr r2, =0x1
	lsl r2, #9
	bic r1, r1, r2
	str r1, [r0]
	
    @delay
    ldr r0, =0xffffff
istimeup:
    sub r0, r0, #0x1
    cmp r0, #0x0
    bne istimeup
    
    @dark led
	ldr r0, =0x0209c000
	ldr r1, [r0]
	ldr r2, =0x1
	lsl r2, #9
	orr r1, r1, r2
	str r1, [r0]
	
	mov pc,lr
	