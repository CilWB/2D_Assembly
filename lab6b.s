	.data
old: .ascii "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n"
new: .ascii "vzprqotkfcmnxyeiabdljsuqwhVZPRQOTKFCMNXYEIABDLJSUQWH\n"
ans: .ascii " "
	.SKIP 80
mes2: .ascii "your input is: \n"
mes1: .ascii "please input your message: "


	.text
	.global main
	.global printf
main:
	LDR r1,=ans
	BL _scanf
	LDR r1,=ans
	BL _printf

	@@@@@@@@@@@ calculate zone
	MOV r0,#0
	LDR r10,=ans
	LDR r11,=old
	LDR r12,=new
	B find
	@@@@@ output zone
out:
	LDR r1,=ans
	BL _printf
	B exit
@@@@@@@@@
find:
	LDRB r1,[r10,r0] 				@ r1 -> ans[i]
	cmp r1,#10				@ if r1=='\n'
	BEQ end					@ back to main
	MOV r2,#0				@ j = 0
_find:
	LDRB r3,[r11,r2] 		@ r3 -> old[j]
	cmp r3,#10				@ if old[j]=='\n'
	BEQ nexti

	cmp r1,r3				@ ans[i] == old[j]
	BEQ replace
	B nextj
@@@@@@@@@@@@@@@@@@@
replace:
	LDRB r5,[r12,r2]			@ r5 -> new[j]
	STRB r5,[r10,r0]
	B nexti
nexti:
	ADD r0,r0,#1
	B find
nextj:
	ADD r2,r2,#1
	B _find
end:
	B out
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
_printf:
	MOV r7,#4
	MOV r0,#1
	MOV r2,#80
	SWI 0
	MOV pc,lr
_scanf:
	MOV r7,#3
	MOV r0,#0
	MOV r2,#80
	SWI 0
	MOV pc,lr

exit:
	MOV r7,#1
	SWI 0
