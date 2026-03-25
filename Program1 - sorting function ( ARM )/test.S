@the information that tells arm-none-eabi-as what arch. to assemble to 
	.cpu arm926ej-s
	.fpu softvfp
@this is code section

@note, we must have the main function for the simulator's linker script
	.text
	.align	2   @align 4 byte
	.global	main

main:
    @ Prologue
    stmfd sp!, {r0, r1, fp, lr}
    add fp, sp, #4

    @ Initialization
    ldr r0, =JUMP_TABLE    @ 加載表格基址
    mov r1, #1             @ 設置索引

    @ Range Check
    cmp r1, #2             @ 確保索引範圍有效
    bhi END_LABEL          @ 如果超出範圍，跳轉到結束

    @ Jump
    ldr pc, [r0, r1, lsl #2]

TABLE1:
    push {r0, r1, lr}
    ldr r0, =string0
    bl printf
    pop {r0, r1, lr}
    b END_LABEL

TABLE2:
    push {r0, r1, lr}
    ldr r0, =string1
    mov r1, #5
    bl printf
    pop {r0, r1, lr}
    b END_LABEL

TABLE3:
    push {r0, r1, lr}
    ldr r0, =string1
    mov r1, #10
    bl printf
    pop {r0, r1, lr}
    b END_LABEL

END_LABEL:
    @ Epilogue
    sub sp, fp, #4
    ldmfd sp!, {r0, r1, fp, lr}
    bx lr

JUMP_TABLE:
    .word TABLE1
    .word TABLE2
    .word TABLE3


@	string
string0:
	.asciz	"Sorting result is:"

string1:
	.asciz	" %d"

Label1:
    .word   0x77777777
    .short  0x1122
    .byte   0x31, 0x32, 0x33, 0x34
	.end
	