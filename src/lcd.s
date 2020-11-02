.global lcd_init

lcd_init:
@init clk moved to clk.s later
    ldr r0, =0x20c80a0
    ldr r1, =0x100021
    str r1, [r0]
	ldr r1, =0x102021
    str r1, [r0]

    @wait pll5 locked
pll5_locked:
    ldr r0, =0x20c80a0
    ldr r1, [r0]
    lsr r1, #31
    cmp r1, #0x1
    bne pll5_locked

	@set num
	ldr r0, =0x20c80b0
	ldr r1, =0x21
	str r1, [r0]
	
	@set denom
	ldr r0, =0x20c80c0
	ldr r1, =0x7d
	str r1, [r0]

    @set cscdr2
    ldr r0, =0x20c4038
    ldr r1, =0x13000	@set devider 3
    str r1, [r0]

    @set cbcmr
    ldr r0, =0x20c4018
    ldr r1, [r0]
    ldr r2, =0x7	@set devider 8
    lsl r2, #23
    orr r1, r2
    str r1, [r0]

    @set ccgr3[cg5]
    ldr r0, =0x20c4074
    ldr r1, [r0]
    ldr r2, =0x3
    lsl r2, #10
    orr r1, r2
    str r1, [r0]

    @set the axi_clk_root if required

@set iomux registers
    ldr r0, =0x20e0000
    ldr r1, =0x0
    str r1, [r0, #0x104]
    str r1, [r0, #0x108]
    str r1, [r0, #0x10c]
    str r1, [r0, #0x110]
@    str r1, [r0, #0x114]
    str r1, [r0, #0x118]
    str r1, [r0, #0x11c]
    str r1, [r0, #0x120]
    str r1, [r0, #0x124]
    str r1, [r0, #0x128]
    str r1, [r0, #0x12c]
    str r1, [r0, #0x130]
    str r1, [r0, #0x134]
    str r1, [r0, #0x138]
    str r1, [r0, #0x13c]
    str r1, [r0, #0x140]
    str r1, [r0, #0x144]
    str r1, [r0, #0x148]
    str r1, [r0, #0x14c]
    str r1, [r0, #0x150]
    str r1, [r0, #0x154]
    str r1, [r0, #0x158]
    str r1, [r0, #0x15c]
    str r1, [r0, #0x160]
    str r1, [r0, #0x164]
    str r1, [r0, #0x168]
    str r1, [r0, #0x16c]
    str r1, [r0, #0x170]
    str r1, [r0, #0x174]

@set pad registers
    ldr r0, =0x20e0000
    ldr r1, =0x1b0b0
    str r1, [r0, #0x390]
    str r1, [r0, #0x394]
    str r1, [r0, #0x398]
    str r1, [r0, #0x39c]
@    str r1, [r0, #0x3a0]
    str r1, [r0, #0x3a4]
    str r1, [r0, #0x3a8]
    str r1, [r0, #0x3ac]
    str r1, [r0, #0x3b0]
    str r1, [r0, #0x3b4]
    str r1, [r0, #0x3b8]
    str r1, [r0, #0x3bc]
    str r1, [r0, #0x3c0]
    str r1, [r0, #0x3c4]
    str r1, [r0, #0x3c8]
    str r1, [r0, #0x3cc]
    str r1, [r0, #0x3d0]
    str r1, [r0, #0x3d4]
    str r1, [r0, #0x3d8]
    str r1, [r0, #0x3dc]
    str r1, [r0, #0x3e0]
    str r1, [r0, #0x3e4]
    str r1, [r0, #0x3e8]
    str r1, [r0, #0x3ec]
    str r1, [r0, #0x3f0]
    str r1, [r0, #0x3f4]
    str r1, [r0, #0x3f8]
    str r1, [r0, #0x3fc]
    str r1, [r0, #0x400]

@set ctrl registers
    @set ctrl
	@end reset state
wait_lcd_dereset:	
    ldr r0, =0x21c8000
	ldr r1, =0x40000000
    str r1, [r0]
	ldr r1, [r0]
	ldr r2, =0x80000000
	and r1, r1, r2
	cmp r1, r2
	beq wait_lcd_dereset

	@disable clk gate
	ldr r1, =0x0
	str r1, [r0]
	
	@set ctrl
	ldr r1, =0xa0f20
    str r1, [r0]

    @set ctrl1
    ldr r0, =0x21c8010
    ldr r1, =0x00070000
    str r1, [r0]

    @set transfer count
    ldr r0, =0x21c8030
    ldr r1, =0x1e00320
    str r1,[r0]

    @set cur_buf
    ldr r0, =0x21c8040
    ldr r1, =0x98000000
    str r1, [r0]

    @set next_buf
    ldr r0, =0x21c8050
    str r1, [r0]

    @set vdctrl0
    ldr r0, =0x21c8000
    ldr r1, =0x1330000a
    str r1, [r0, #0x70]

    @set vdctrl1
    ldr r1, =0x20d
    str r1, [r0, #0x80]

    @set vdctrl2
    ldr r1, =0x500420
    str r1, [r0, #0x90]

    @set vdctrl3
    ldr r1, =0x2e0017
    str r1, [r0, #0xa0]

    @set vdctrl4
    ldr r1, =0x40320
    str r1, [r0, #0xb0]



@light the backup led GPIO1_IO08
	ldr r0, =0x20e007c
	ldr r1, =0x5
	str r1, [r0]

	ldr r0, =0x209c004	@set write mode
	ldr r1, [r0]
    ldr r2, =0x1
	lsl r2, #8
	orr r1, r2
	str r1, [r0]

	ldr r0, =0x209c000	@light backup light
	ldr r1, [r0]
	orr r1, r2
	str r1, [r0]

    @enable lcd
    ldr r0, =0x21c8000
    ldr r1, =0xa0f21
    str r1, [r0]
	
	@delay wait fifo
	ldr r0, =0xffffff
delay_fifo:
	NOP
	NOP
	sub r0, r0, #0x1
	cmp r0, #0x1
	bne delay_fifo
	
    mov pc, lr

.global write_rgb_data

write_rgb_data:
	ldr r1, =0x98000000
	ldr r2, =0x0
write_count:
	str r0, [r1, r2]
	add r2, #0x4
	ldr r3, =0x177000
	cmp r2, r3
	bne write_count
	
	mov pc, lr
	