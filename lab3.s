	.global _start
_start:
_read:
	MOV r7,#3
	MOV r0,#0
	LDR r1,=in
	MOV r2,#2
	SWI 0

_read2:

        MOV r7,#3
        MOV r0,#0
        LDR r1,=in2
        MOV r2,#2
        SWI 0

tran:
	MOV r6,#10

	LDR r3,=in
	LDRB r4,[r3,#0]
	SUB r11,r4,#48
	MOV r10,r11
	MUL r11,r10,r6
	LDRB r4,[r3,#1]
	SUB r4,r4,#48
	ADD r11,r11,r4
	SWI 0

	LDR r8,=in2
	LDRB r9,[r8,#0]
	SUB r12,r9,#48
	MOV r10,r12
	MUL r12,r10,r6
	LDRB r9,[r8,#1]
	SUB r9,r9,#48
	ADD r12,r12,r9
	SWI 0

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	ADD r0,r11,r12
	MOV r5,#0
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
cil:
	CMP r0,#10
	BLT isus
	ADD r5,r5,#1
	SUB r0,r0,#10
	B cil
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
isus:
	LDR r3,=sum
	ADD r0,r0,#48
	ADD r5,r5,#48
	STRB r0,[r3,#1]
	STRB r5,[r3,#0]
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	MOV r7,#4
	MOV r2,#3
	MOV r0,#1
	LDR r1,=sum
	SWI 0
_exit:
	MOV R7,#1
	SWI 0

	.data
sum: .asciz "xy\n"
in: .asciz "  "
in2: .asciz "  "
