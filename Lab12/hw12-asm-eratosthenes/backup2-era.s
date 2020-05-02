	.global _Z3eraPjj

_Z3eraPjj:
	push {r4-r11}

	@r0 is the start of the big array
	@r1 is the number we count up to, then later the index of that one
	@r2 is the total number of primes found so far
	@r3 is the index we are currently at
	@r4 is the number the index corrisponds to (and sometimes 4x it)
	@r5 is the pattern we are going to set everything to
	@r6 is the remander of the number mod 32
	@r7 is the current element in big array
	@r8 will be the final element in the big array
	@r9 is the counter for the number of write cycles
	@r10 is a temp variable and the current part of big array
	@r11 is the first part of big array with the current index in it

@SECTION 1: Init and multiples of 3 eliminated

	mov r2, #2 @We have found 2 and 3
    mov r3, #1 @this means 3, 2x+1

	@lsl r4, r3, #1
    @add r4, #1    
	mov r4, #3

	rsb r6, r4, #32
	mov r5, #1
.L1:				@Create the pattern to set primes
	lsl r5, r4
	add r5, #1
	subs r6, r4
	bgt .L1
	lsl r5, r3
					@Define the end of the list
	add r8, r1, #63
	lsr r8, #4 		@divided by 32, by 2, then multiplied by 4
	add r8, r0	
	bic r8, #3	

	lsr r1, #1	

	mov r9, #0		@Offset of each iteration
	lsl r4, #2		@Step of each iteration
.L3:
	add r7, r0, r9
	
.L2:
	str r5, [r7], r4
	cmp r7, r8
	blt .L2

	@lsl r10, r5, r6
	@rsb r6, #32
	@lsr r5, r5, r6
	@rsb r6, #32
	@orr r5, r10
	lsl r5, #1
	lsr r10, r5, #3
	orr r5, r10
	add r9, #4
	cmp r9, r4
	bne .L3

	add r3, #1

@SECTION 2: Prime numbers below 32
.SEC2:
	ldr r11, [r0]		@Load the first 32 primes, select the current one
	mov r5, #1
	lsl r5, r3
.L4:
	cmp r3, #16	@Once we hit 16, go on to section 3
	bge .SEC3
	ands r10, r5, r11
	add r3, #1
	lsl r5, #1
	@cmp r10, #0
	bne .L4
	
	sub r3, #1
	add r2, #1
	lsl r4, r3, #3 @4 times the prime number
	add r4, #4
    
	@push {r0-r3}
    @mov r0, r4
	@lsr r0, #2
    @bl _Z5printi
    @pop {r0-r3}
	
	mov r6, r3
	mov r9, #0

	lsr r11, r4, #2 @The real prime number
	
	push {r0-r3}
	mov r0, r11
	bl _Z5printi
	pop {r0-r3}

	sub r10, r11, #32
    mov r5, #1
.L5:
    lsl r5, r11
    add r5, #1
    adds r10, r11
    blt .L5
	@Now have 1s separated by the prime number, rightmost is 1
	lsl r5, r6		@Now make r6-1 zeros
	add r7, r0, r9
.L6:	
	ldr r10, [r7]
    orr r10, r5
    str r10, [r7], r4
    cmp r7, r8
    ble .L6

    add r9, #4
    cmp r9, r4
    addeq r3, #1
    beq .SEC2
.DEBUG:
.L7:
	clz r10, r5			@r10 should be zeros in the beginning of r5
	lsr r7, r4, #2
	sub r10, r7, r10	@Get the remaining pattern needed in the next one
	lsr r5, r6
	lsl r5, r10
	lsl r6, r5, r7		
	orr r5, r6
	mov r6, r10			@Save the difference
	@add r6, r10	
	@cmp r6, r11
	@subge r6, r11
    add r7, r0, r9
	b .L6

@SECTION 3: Prime numbers above 32

.SEC3:
	@New Definitions:
	
    @r0 is the start of the big array
    @r1 is the number we count up to
    @r2 is the total number of primes found so far
    @r3 is the index we are currently at
    @r4 is the number the index corrisponds to (and sometimes 4x it)
    @r5 is the pattern and the current bit to flip (whole index)
    @r6 is the remander of the number and current bit to flip
    @r7 is the current element in big array
    @r8 will be the final element in the big array
    @r9 is a temp variable and the counter for the number of write cycles
    @r10 is a temp variable and the current part of big array
    @r11 is the first part of big array with the current index in it

	lsr r7, r3, #3 		@Div by 32 and mult by 4 to get index number
	bic r7, #3 			@Round to nearest index
	add r7, r0			@Get the address	

	and r6, r3, #31		@Setup r5 as selector
	mov r5, #1
	lsl r5, r6

	ldr r11, [r7]		@Grab the bits in question
.L8:
	cmp r3, r1			@If we are done, leave
	bge .DONE
	cmp r5, #0			@If our selector is done, grab the next bits
	beq .SEC3
	ands r9, r5, r11	@See if it isn't prime
	add r3, #1			@Go on to the next one (Had to do it this way)
	lsl r5, #1			
	@cmp r9, #0
	bne .L8				@If it isnt prime, go back

	sub r3, #1			@Go to the correct number
	add r2, #1			@Mark that we found one
	lsl r4, r3, #1		@Put the real value in r4
	add r4, #1

	push {r0-r3}
    mov r0, r4
    bl _Z5printi
    pop {r0-r3}

    @push {r0-r3}
    @mov r0, r4
    @bl _Z5printi
    @pop {r0-r3}

	add r6, r3, r4		@First index of multiple of this number
	lsr r7, r6, #3		@Move the array index into r7
	bic r7, #3
	add r7, r0
	cmp r7, r8 
	bgt .SEC4
	
.L9:
	ldr r11, [r7]
	mov r9, #1			@Create matching pattern in r9, by last bits of r6
	and r10, r6, #31
	lsl r9, r10
	orr r11, r9			@Save the changes
	str r11, [r7]
	add r6, r4			@Repeat logic from earlier
	lsr r7, r6, #3
	bic r7, #3
	add r7, r0
	cmp r7, r8
	blt .L9
	
	add r3,#1
	b .SEC3

@SECTION 4: above sqrt(n), no more sieving, just counting
.SEC4:
	add r3, #1

	@push {r0-r3}
    @mov r0, r3
	@lsl r0, #1
	@add r0, #1
    @bl _Z5printi
	@mov r0, #128
 	@bl _Z5printi
    @pop {r0-r3}

	lsr r7, r3, #3
	bic r7, #3
	add r7, r0
	
	mov r5, #1
	and r10, r3, #31
	lsl r5, r10

.L10:
	ldr r11, [r7], #4
.L11:
	cmp r3, r1
	bge .DONE
	ands r9, r5, r11
	addeq r2, #1
	bne .NOT
	push {r0-r3}
    mov r0, r3
	lsl r0, #1
	add r0, #1
    bl _Z5printi
    pop {r0-r3}
.NOT:
	add r3, #1
	ror r5, #31
	cmp r5, #1
	bne .L11
	b .L10
	
@Cleanup:
.DONE:
	@push {r0-r3}
	@mov r0, r2
    @bl _Z5printi
    @pop {r0-r3}
	mov r0, r2
	pop {r4-r11}
	bx lr

