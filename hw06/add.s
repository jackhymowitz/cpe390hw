	.global _Z3addPiPKiS1_i

_Z3addPiPKiS1_i:
	@ r0=address of c (the destination)
	@ r1=address of a
	@r2 = address of b
	@r3 = number of elements to do

	push	{r4,r5}

.L1:
	ldr 	r4,[r1],#4
	ldr		r5,[r2],#4
	add		r4,r5
	str		r4,[r0],#4
	subs	r3,#1
	bne		.L1
	
	pop		{r4,r5}
	bx lr
