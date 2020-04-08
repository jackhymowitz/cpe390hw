	.global _Z8checksumPKc

_Z8checksumPKc:
	mov r2, #0
.L1:
	ldrb r1, [r0]
	add r2, r1
	add r0, #1
	cmp r1, #0
	bne .L1
	mov r0, r2
	bx lr
