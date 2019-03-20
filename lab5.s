/* printf.s */
	.data
	.balign 4
message1: .asciz "Please enter a number : "
	.balign 4
message2: .asciz "I read the number %d\n"
	.balign 4
scan_pattern: .asciz "%d"
	.balign 4
number_read: .word 0
	.balign 4
return: .word 0

	.text
	.global main
	.global printf
	.global scanf
main:
	LDR r1, =return @ r1=&return
	STR lr, [r1] @ *r1=lr
	LDR r0, =message1 @ print message1
	BL printf
	LDR r0, =scan_pattern @ input via scanf
	LDR r1, =number_read
	BL scanf
	LDR r1, =number_read
	LDR r1, [r1] @ r1 <- *r1
	B cal400
showVal:
	LDR r0, =message2
	BL printf
	LDR r0, =number_read
	LDR r0, [r0]
	LDR lr,=return
	LDR lr, [lr]
	BX LR @ swap lr,pc
@@@@@@@@@@@@@@@@@@@@
cal400:
	cmp r1,#400
	BEQ _yes
	BLT cal100
	SUB r1,r1,#400
	B cal400
cal100:
	cmp r1,#100
	BEQ _no
	BLT cal4
	SUB r1,r1,#100
	B cal100
cal4:
	cmp r1,#0
	BEQ _yes
	BLT _no
	SUB r1,r1,#4
	B cal4
@@@@@@@@@@@@@@@@@@@ output
_yes:
	MOV r0,#1
	LDR r1,=yes
	MOV r2,#5
	MOV r7,#4
	SWI 0
	B _exit
_no:
	MOV r0,#1
	LDR r1,=no
	MOV r2,#5
	MOV r7,#4
	SWI 0
_exit:
	MOV r7,#1
	SWI 0


@@@@@@@@@ end
	.data
yes: .ascii "YES!\n"
no: .ascii "NOO!\n"
