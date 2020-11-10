/*include function:
*	1. GIC_init
*	2. save interruput vector	*/

.global main
main:
	/******GIC_init******/
	@获取GIC寄存器基地址
	mrc p15, 4, r0, c15, c0, 0		@获取GIC寄存器基地址
	ldr r1, =0xffff0000
	and r0, r0, r1
	add r7, r0, #0x1000				@GICD寄存器基地址,存入r7
	add r8, r0, #0x2000				@GICC寄存器基地址，存入r8
	
	@读D_typer寄存器，得到GIC最大支持终端个数
	ldr r1, [r7, #004]				@读取TYPER寄存器内容，存入r1
	and r1, r1, #0x1f
	add r1, r1, #0x1
	
	@关闭所有中断
	ldr r0, [r7, #0x180]			@D_ICENABLER基地址存入r0
	ldr r3, =0x0
	ldr r2, =0xffffffff
	lsl r1, #2						@r1×4
shutdown_int:
	str r2, [r0, r3]
	add r3, r3, #0x4
	cmp r3, r1
	bne shutdown_int
	
	@设置优先级寄存器
	ldr r1, =0xf8
	str r1, [r8, #0x4]
	
	@设置抢占寄存器
	ldr r1, =0x2
	str r1, [r8, #0x8]
	
	@使能分发器
	ldr r1, 0x1
	str r1, [r7]
	@使能CPU接口
	str r1, [r8]
	
	/******将中断矢量表地址存入VBR寄存器******/
	ldr r0, =0x878000000
	mcr p15, 0, c12, c0, 0
	
	
	bl clk_init
	bl uart_init
	bl led_init
	bl key_init
	bl led_up
main_loop:
	b main_loop
	