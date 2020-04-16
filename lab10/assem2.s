.global _Z6setBitii
.global _Z8clearBitii
.global _Z4flipii
.global _Z11replaceBitsiii
.global _Z10buildColoriii

	@ORR e1800002

	@BIC e1c00002

	@EOR e0200002

_Z6setBitii:
	mov r3, #0xe180
	b .FUNC

_Z8clearBitii:
	mov r3, #0xe1c0
	b .FUNC

_Z4flipii:
	mov r3, #0xe020
.FUNC:
	strh r3, [<.OR>]
	mov r2, #1
	lsl r2, r1
.OR:	
	orr r0, r2 
	bx lr

_Z11replaceBitsii:
    and r0, r1
    bic r3, r1
    orr r0, r3
    bx lr

_Z10buildColoriii:
    lsl r0, #16
    lsl r1, #8
    orr r0, r1
    orr r0, r2
    bx lr

