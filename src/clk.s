@init cpu clk and uart clk

.global clk_init

clk_init:
    @cpu clk init
    @swith cpu clk to 24 M
    ldr r0, =0x20c400c
    ldr r1, =0x4
    str r1, [r0]
    
    @set pll1
    ldr r0, =0x20c8000
    ldr r1, =0x42
    str r1, [r0]
    
    @enable and wait pll1 locked
    ldr r1, =0x2042
    str r1, [r0]
ispll1locked:
    ldr r1, [r0]
    lsr r1, #31
    and r1, #0x1
    cmp r1, #0x1
    bne ispll1locked
    
    @switch cpu clk to pll1
    ldr r0, =0x20c400c
    ldr r1, =0x0
    str r1, [r0]
    
    @set cpu root clk divider
    ldr r0, =0x20c4010
    ldr =0x1
    str r1, [r0]
    
    @uart clk init ,i.e pll3 init
    @set pll3
    ldr r0, =0x20c8010
    ldr r1, =0x2040
    str r1, [r0]
    
    @enable pll3 wait pll3 locked
ispll3locked:
    ldr r0,=0x20c8010
    ldr r1, [r0]
    lsr r1, #31
    and r1, #0x1
    cmp r1, #0x1
    bne ispll3locked
    
    
    mov pc, lr
    