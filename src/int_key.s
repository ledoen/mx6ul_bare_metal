/*
*include functions:
*1. system_irq_handler
*2. key_init
*3. key_handler
*/
.global key_init
/*设置GPIO1_2管脚模式，中断模式*/

key_init:
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
	ldr r1, =0x30
	str r1, [r0]
	
	@设置GPIO_IMR寄存器，允许GPIO1_IO02中断
	ldr r0, =0x0209c014
	ldr r1, [r0]
	orr r1, r1, #(0x1<<2)
	str r1, [r0]
	
	@设置GPIO_IMR寄存器，清除GPIO1_IO02中断标志
	ldr r0, =0x0209c018
	ldr r1, [r0]
	orr r1, r1, #(0x1<<2)
	str r1, [r0]
	
	@开启IRQ中断
	mrc p15, 4, r0, c15, c0, 0		@获取GIC寄存器基地址
	ldr r1, =0xffff0000
	and r0, r0, r1
	add r7, r0, #0x1000				@GICD寄存器基地址,存入r7
	add r7, r7, #0x10c				@GICC_DENABLER寄存器地址
	ldr r1, =0x4
	str r1, [r7]
	
	mov pc, lr

.global system_irq_handler
system_irq_handler:
	ldr r1, =0x62			/*GPIO1_0-15对应的中断编号为98*/
	cmp r0, r1
	movne pc, lr			/*如果不等，不处理返回
							*相等，则执行key_handler*/
	
key_handler:
	ldr r0, =0x0209c000		/*打开led*/
	ldr r1, [r0]
	ldr r2, =0x1
	lsl r2, #9
	bic r1, r1, r2
	str r1, [r0]
	/*延时*/
	ldr r1, =0xffffff
anti_fake_delay:
	nop
	nop
	sub r1, r1, #0x1
	cmp r1, #0x1
	bne anti_fake_delay
	
	@清零中断标志位
	ldr r0, =0x0209c018
	ldr r1, [r0]
	orr r1, r1, #(0x1<<2)
	str r1, [r0]	
	
	mov pc, lr
	