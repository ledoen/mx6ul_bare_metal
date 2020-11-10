/*
*include functions:
*1. system_irq_handler
*2. key_init
*3. key_handler
*/
.global key_init
key_init:
/*设置GPIO1_2管脚模式，中断模式*/
	ldr r0, =0x020e0064		@将IOMUX寄存器地址放入r0
	ldr r1, [r0]		@将寄存器值读出放入r1
	bic r1, r1, #0xf		@将r1的低4位清零
	orr r1, #0x5			@将r1的低4位置为0101b
	str r1, [r0]		@将r1的值放回IOMUX寄存器

	@set GPIO_PAD Register
	ldr r0, =0x020e02f0
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
	lsl r2, #2
	bic r1, r2
	str r1, [r0]	
	
	@设置GPIO_ICR寄存器
	ldr r0, =0x0209c00c
	ldr r1, [r0]
	orr r1, r1, #(0x3 << 4)
	str r1, [r0]
	
	@设置GPIO_IMR寄存器，允许GPIO1_IO02中断
	ldr r0, =0x0209c14
	ldr r1, [r0]
	orr r1, r1, #(0x1 << 2)
	str r1, [r0]
	
	mov pc, lr

.global system_irq_handler
system_irq_handler:
	ldr r1, =0x62			/*GPIO1_0-15对应的中断编号为98*/
	cmp r0, r1
	movne pc, lr			/*如果不等，不处理返回
							*相等，则执行key_handler*/
	
key_handler:
	ldr r1, =0xffff
	/*延时*/
anti_fake_delay:
	nop
	nop
	sub r1, r1, #0x1
	cmp r1, #0x1
	bne anti_fake_delay
	
	/*判断GPIO1_2数据寄存器是否为0,如果为0，将r6置为1*/
    ldr r0, =0x209C000
    ldr r1, [r0]
    @取出第二位,判断是否为1
    lsr r1, #2
    and r1, r1, #0x1
    cmp r1, #0x1
	
	ldrne r6, =0x1
	mov pc, lr