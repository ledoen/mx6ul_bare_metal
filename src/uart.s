.global uart_init
@init the uart register
uart_init:

	@disable uart
    ldr r0, =0x2020080
    ldr r1, =0x0
    str r1, [r0]
		
	
    @set pad gpio1_16-17 ALT0
    ldr r0, =0x20e0084
    ldr r1, [r0]
    ldr r2, =0xf
    bic r1, r2
    str r1, [r0]
    
    ldr r0, =0x20e0088
    ldr r1, [r0]
    ldr r2, =0xf
    bic r1, r2
    str r1, [r0]
    
    ldr r0, =0x20e0624  @set daisy register
    ldr r1, [r0]
    orr r1, #0x3
    str r1, [r0]
    
    @set ucr2 for data format
    ldr r0, =0x2020084
    ldr r1, =0x4027
    str r1, [r0]
    
    @set ucr3 0x4
    ldr r0, =0x2020088
    ldr r1, =0x4
    str r1, [r0]
	
    @set ufcr for dte/dce
    ldr r0, =0x2020090
    ldr r1, =0x80
    str r1, [r0]
    
    @set clk source
    ldr r0, =0x20c4024
    ldr r1, [r0]
    ldr r2, =0x7f
    bic r1, r2
    str r1, [r0]
    
    @set ubir ubmr for baudrate
    ldr r0, =0x20200a4
    ldr r1, =0x47
    str r1, [r0]
    
    ldr r0, =0x20200a8
    ldr r1, =0x270
    str r1, [r0]
    
    @enable clk
    ldr r0, =0x20c407c
    ldr r1, [r0]
    ldr r2, =0x03000000
    orr r1, r2
    str r1, [r0]
	

	
    @enable uart
    ldr r0, =0x2020080
    ldr r1, =0x1
    str r1, [r0]
    
    mov pc, lr
    
putc:
	lsr r4, r7, #28
isbusy:	
    ldr r5, =0x2020098
    ldr r6, [r5]
    lsr r6, #3
    and r6, #0x1
    cmp r6, #0x1
    bne isbusy
	cmp r4, #0x9
	addls r4, #0x30
	addhi r4, #0x57
	ldr r5, =0x2020040
    str r4, [r5]
    mov pc, lr
    

.global uart_pri_r0

uart_pri_r0:
    ldr r1, =0x8 		@setup repeat count 8 in r1
	ldr r2, [r0]
putbyte:	
	and r7, r2, #0xf0000000	@get lower 4bit of r2
	bl putc				@put one byte
	lsl r2, #4			@right shift r2 4 bits 
	cmp r1, #0x1		@compare repeat count with 0x0
	subne r1, #1		@repeat count -1
	bne putbyte
    mov pc, lr

	@reset uart
	ldr r0, =0x2020084
	ldr r2, =0x1
	ldr r1, [r0]
	bic r1, r2
	str r1, [r0]
isreset:
	ldr r0, =0x20200b4
	ldr r1, [r0]
	and r1, r2
	cmp r1, #0x1
	beq isreset
	