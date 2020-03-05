.global _Z2a1j
_Z2a1j:
	@r0 is end value
	@r1 is ctr
	mov r1,#0
loop:
	add r1,#1
	cmp r0,r1
	bne loop
	bx lr

.global _Z2a2j
_Z2a2j:
	@r0 is counter
	subs R0,#1
	bne _Z2a2j
	bx lr
