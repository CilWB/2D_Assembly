	.data
t: .word 	7890
s: .word 	0x80000000
e: .word 	0x7F800000
f: .word 	0x007FFFFF
num: .word 	0x00800000
hello: .word 0
@ 0b____ is binary
@ 0x____ is hexadecimal
@ 0____ octal is finding T^T
testval:
	.float 0.5
	.float 0.25
	.float -1.0
	.float 100.0
	.float 1234.567
	.float -9876.543
	.float 7070.7070
	.float 3.3333
	.float 694.3e-9
	.float 6.0221e2
	.float 6.0221e23
	.word 0 @ end of list
message: .asciz "data is %d\n"
d: .asciz "%d"
dd: .asciz "_%d_"
_dot: .asciz "."
_endl: .asciz "\n"
_minus: .asciz "-"
	.text
	.global	main
	.global paintf
main:

	LDR r10,=testval			@ float *r10 = &testval
	MOV r9,#0				@ i = 0
	LDR r1,[r10,r9]				@ r1 = *r10[i]
Loop:						@ for(i=0;i!=44;i+=4)
	CMP r9,#44				@ if (i==44) go exit
	BEQ exit
	LDR r1,[r10,r9]				@ r1=*tesetval[i]
	BL check_neg				@ check&print negative
	BL check_exp				@ check&print value
	BL endl					@ print '\n'
	ADD r9,r9,#4
	B Loop

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
check_neg:
	STMDB sp!,{r0-r3,lr}
	MOV r2,r1
	LSR r2,#31				@ shift right 31 bits
	CMP r2,#1				@ cmp sign bit with #1
	BLEQ minus				@ if(signbit==1) go print minus
	LDMIA sp!,{r0-r3,lr}
	BX LR
check_exp:
	STMDB sp!,{r0-r11,lr}

	LDR r2,=e				@ r2 = &e
	LDR r2,[r2]				@ r2 = 0x7F800000
	AND r3,r2,r1				@ r3 = e&value = e&r1
	LSR r3,#23				@ r3 = exponent in decimal

	LDR r2,=f				@ r2 = &f
	LDR r2,[r2]				@ r2 = x007FFFFF
	AND r4,r2,r1				@ r4 = r2&r1 = fraction 23 bits
	LDR r2,=num
	LDR r2,[r2]				@ r2 = x00800000
	ORR r4,r4,r2				@ r4 = r4|r2 = fraction 24 bits

	MOV r5,r4
	SUB r3,r3,#127
@@@@@@@@@@@@@@@@@@@@ interger zone
	CMP r3,#0				@
	BLT intRsh 				@ exponent<0 go Rsh

	SUB r3,r3,#23				@ exponent>0 go Lsh
	CMP r3,#0				@ intLsh has 2 cases to prevent from overflow Lsh
	BGT intLsh_L				@ case Rsh in intLsh
	MVN r3,r3
	ADD r3,r3,#1				@ 2's com before shift for num
	MOV r6,r3				@ exponent for fraction
	LSR r4,r3				@ intLsh ->shifting R for make integer
	B next
intLsh_L:
	MOV r6,r3
	LSL r4,r3				@ intLsh -> shifting L for make integer
	B next
intRsh:
	MVN r3,r3
	ADD r3,r3,#1				@ intRsh for nake integer
	ADD r6,r3,#23
	MOV r3,r6
	LSR r4,r3
next:
	MOV r1,r4
	BL printint				@ print integer
@@@@@@@@@@@@@@@@  dot zone
	BL dot					@ print '.'
@@@@@@@@@@@@@@@@ fraction zone
	MOV r7,#32
	SUB r6,r7,r6				@ r6 = exponent in positive decimal
	CMP r6,#0
	BLT right_
	LSL r5,r6				@ r5 = fraction
	B nextt
right_:						@ incase right shifting
	MOV r8,#23
	ADD r8,r8,r6
	CMP r8,#0
	BNE rsh
	SUB r6,r6,#1				@ increase exponent 1 for 24th bit 
rsh:
	MVN r6,r6
	ADD r6,r6,#1
	LSR r5,r6				@ r5 = fraction
nextt:
	MOV r8,#10
fracc:
	UMULL r5,r1,r8,r5 
	BL printint
	CMP r5,#0
	BNE fracc		// end printf %f
	LDMIA sp!,{r0-r11,lr}
	BX LR
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
exit:
	MOV r7,#1
	SWI 0
dot:
	STMDB sp!,{r0-r11,lr}
	LDR r0,=_dot
	BL printf
	LDMIA sp!,{r0-r11,lr}
	MOV pc,lr
minus:
	STMDB sp!,{r0,lr}
	LDR r0,=_minus
	BL printf
	LDMIA sp!,{r0,lr}
	MOV pc,lr
printint:
	STMDB sp!,{r0-r11,lr}
	LDR r0,=d
	BL printf
	LDMIA sp!,{r0-r11,lr}
	BX lr
printint_:
	STMDB sp!,{r0-r11,lr}
	LDR r0,=dd
	BL printf
	LDMIA sp!,{r0-r11,lr}
	BX lr
endl:
	push {r0,lr}
	LDR r0,=_endl
	BL printf
	pop {r0,lr}
	BX lr
