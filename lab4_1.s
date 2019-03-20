	.text
	.global _start
_start:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	MOV r0,#0
	LDR r1,=input
	MOV r2,#2
	MOV r7,#3
	SWI 0

	LDR r1,=input
	LDRB r2,[r1,#0]
	SUB r2,r2,#48
	MOV r3,#10
	MUL r0,r3,r2
	LDRB r2,[r1,#1]
	SUB r2,r2,#48
	ADD r0,r0,r2

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ calculator part
	MOV r11,#49
	LDR r12,=ans
cal64:
	cmp r0,#64
	BLO cal32
	SUB r0,r0,#64
	STRB r11,[r12,#1]
cal32:
	cmp r0,#32
	BLO cal16
	SUB r0,r0,#32
	STRB r11,[r12,#2]
cal16:
	cmp r0,#16
	BLO cal8
	SUB r0,r0,#16
	STRB r11,[r12,#3]
cal8:
	cmp r0,#8
	BLO cal4
	SUB r0,r0,#8
	STRB r11,[r12,#4]
cal4:
	cmp r0,#4
	BLO cal2
	SUB r0,r0,#4
	STRB r11,[r12,#5]
cal2:
	cmp r0,#2
	BLO cal1
	SUB r0,r0,#2
	STRB r11,[r12,#6]
cal1:
	cmp r0,#1
	BLO print
	STRB r11,[r12,#7]

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ print part
print:
	MOV r0,#1
	LDR r1,=ans
	MOV r2,#9
	MOV r7,#4
	SWI 0
_exit:
	MOV r7,#1
	SWI 0

	.data
ans: .asciz "00000000\n"
input: .asciz "77"
