	.global _Z3dotPdS_
_Z3dotPdS_:	
	@ r0 = first array    r1 = second array
	@ answer is returned in d0

	@ first element of first array x[0] = [r0]   vldr d0, [r0]
	@ first elemetn of second array y[0] = [r1]
	@ second elements of first array x[1] =vldr.f64 d0, [r0, #8]
	@ second elements of second array y[1] = ???	

	@  [r0]    [r0, #8]   [r0, #16]

	@if the vector is BIG
	@ use [r0]
	@ add r0, #8

	mov			r2,#3

_Z4dot2PdS_i:
	vldr.f64	d0,.ZERO
.L1:
	vldr.f64	d1,[r0]
	vldr.f64	d2,[r1]
	vmla.f64	d0,d1,d2
	add			r0,#8
	add			r1,#8
	subs		r2,#1
	bne 		.L1
	bx			lr

.ZERO: 
	.word 0x00000000
	.word 0x00000000
