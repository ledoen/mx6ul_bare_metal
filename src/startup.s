/*use interruput*/
/*
*contain :
*1. top interruput vector table
*2. top handler entry
*/

/*top interruput vector table, will be link at 0x87800000*/
.global __top_vector_table

__top_vector_table:
	ldr pc, =reset_handler
	ldr pc, =undefined_handler
	ldr pc, =svc_handler
	ldr pc, =pre_abort_handler
	ldr pc, =data_abort_handler
	.word 0
	ldr pc, =irq_handler
	ldr pc, =fiq_handler
	
/*reset handler*/
reset_handler:
	cpsid i		/*close interruput*/

	/*set cp15 register to close I cache, D cache, and MMU*/
	mrc p15, 0, r0, c1, c0, 0	/*read cp15 register*/
	bic r0, r0, #(0x1<<12)		/*close I cache*/
	bic r0, r0, #(0x1<<2)		/*close D cache*/
	bic r0, r0, #0x2
	bic r0, r0, #(0x1<<11)
	bic r0, r0, #0x1			/*close MMU*/
	mcr p15, 0, r0, c1, c0, 0
	
	/*set stack for irq mode*/
	cps #0x12					/*enter irq mode */
	ldr sp, =0x80600000
	
	/*set stack for system mode*/
	cps #0x1f					/*enter system mode*/
	ldr sp, =0x80400000

	/*set stack for supervisor mode*/
	cps #0x13					/*enter supervisor mode */
	ldr sp, =0x80200000
	
	/*enable irq interruput*/
	mrs r0, cpsr
	bic r0, r0, #0x80			/*cpsr bit7 is irq mask bit*/
	msr cpsr, r0

	cpsie i 					/*open interruput*/
	b main						/*go to main */

/*undefined handler*/
undefined_handler:
	b undefined_handler

/*svc handler*/
svc_handler:
	ldr r0, =svc_handler
	bx r0

/*pre_abort_handler*/
pre_abort_handler:
	ldr r0, =pre_abort_handler
	bx r0

/*data_abort_handler*/
data_abort_handler:
	ldr r0, =data_abort_handler
	bx r0

/*irq_handler*/
irq_handler:
	/*保护现场*/
	push {lr}					/*save return address +4*/
	push {r0-r3, r12}			/*save registers*/
	
	mrs r0, spsr				/*保存备份程序寄存器*/
	push {r0}
	
	mrc p15, 4, r1, c15, c0, 0	/*GIC基地址*/
	add r1, r1, #0x2000			/*GICC基地址*/
	ldr r0, [r1, #0xc]			/*读取GICC_IAR寄存器的内容
								*（中断编号），存入r0*/
	
	push {r0, r1}
	
	cps #0x13					/*进入supervi模式 */
	push {lr}					/*保存superv模式的lr*/
	
	ldr r2, =system_irq_handler
	blx r2						/*跳转到二级中断处理函数
								*参数在r0中*/
	
	/*恢复现场*/
	pop {lr}
	
	cps #0x12					/*返回irq模式 */
	
	pop {r0, r1}
	
	str r0, [r1, #0x10]			/*中断执行完成，写到EOIR*/
	
	pop {r0}
	msr spsr_cxsf, r0
	pop {r0-r3, r12}
	pop {lr}
	subs pc, lr, #4				/*将lr-4赋给pc*/

/*fiq_handler*/
fiq_handler:
	ldr r0, =fiq_handler
	bx r0
