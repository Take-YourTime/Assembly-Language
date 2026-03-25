@ the information that tells arm-none-eabi-as what arch. to assemble to 
    .cpu arm926ej-s
    .fpu softvfp

@ this is code section
    .text
    .align  2   @ align 4 byte
    .global main


main:
    mov     r1, pc
    b       start
instruction_start:
    .include "test.S"               @ 嵌入測試檔案
                                    @ 注意！嵌入檔一定要放在這裡，不然branch的偏移值會錯誤    
start:
    mov     r2, pc
    sub     r1, r2, r1
    sub     r1, r1, #8

    @ prologue
    stmfd   sp!, {r0, r1, fp, lr}   @ 命令列呼叫 → r0 = argc, r1 = argv
    add     fp, sp, #4
    
    @ initialization
    ldr     r0, =instruction_start  @ 初始化指令起始地址             
    mov     r2, #0                  @ 初始化 pc（程式計數器）

    @ output head file
    push    {r0, r1, r2}
    ldr     r0, =string0
    bl      printf
    pop     {r0, r1, r2}

deasm_loop:
    ldr     r3, [r0]        @ 加載當前指令
@@須改下面這行
    cmp     r2,  r1         @ 如果指令為空，結束反組譯
    beq     end_deasm

    push    {r0, r1, r2}
    bl      identify_instruction    @ 辨識指令類型
	pop     {r0, r1, r2}

    add     r0, r0, #4              @ 指向下一條指令
    add     r2, r2, #4              @ 增加 pc 值
    b       deasm_loop


@ function
identify_instruction:
    and     r4, r3, #0x0F000000     @ 提取branch的opcode
    cmp     r4, #0x0A000000         @ 是否為 b ？
    beq     is_branch

    and     r4, r3, #0x0C000000     @ 判斷是不是16道data process
    cmp     r4, #0x00000000
    bne     is_none         
    
    and     r4, r3, #0x01E00000     @ 提取16道data process的opcode
    cmp     r4, #0x00000000         @ 是否為 and
    beq     is_and
    cmp     r4, #0x00200000         @ 是否為 eor
    beq     is_eor
    cmp     r4, #0x00400000         @ 是否為 sub
    beq     is_sub
    cmp     r4, #0x00600000         @ 是否為 rsb
    beq     is_rsb
    cmp     r4, #0x00800000         @ 是否為 add
    beq     is_add
    cmp     r4, #0x00A00000         @ 是否為 adc
    beq     is_adc
    cmp     r4, #0x00C00000         @ 是否為 sbc
    beq     is_sbc
    cmp     r4, #0x00E00000         @ 是否為 rsc
    beq     is_rsc
    cmp     r4, #0x01000000         @ 是否為 tst
    beq     is_tst
    cmp     r4, #0x01200000         @ 是否為 teq
    beq     is_teq
    cmp     r4, #0x01400000         @ 是否為 cmp
    beq     is_cmp
    cmp     r4, #0x01600000         @ 是否為 cmn
    beq     is_cmn
    cmp     r4, #0x01800000         @ 是否為 orr
    beq     is_orr
    cmp     r4, #0x01A00000         @ 是否為 mov
    beq     is_mov
    cmp     r4, #0x01C00000         @ 是否為 bic
    beq     is_bic
    cmp     r4, #0x01E00000         @ 是否為 mvn
    beq     is_mvn
is_none:
    push    {r0, r1, lr}        @ 注意！此處因為是在函式中再次呼叫函式，因此需要保存 lr 寄存器
    ldr     r0, =string_none
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_and:
    push    {r0, r1, lr}
    ldr     r0, =string_and
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_eor:
    push    {r0, r1, lr}
    ldr     r0, =string_eor
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_sub:
    push    {r0, r1, lr}
    ldr     r0, =string_sub
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_rsb:
    push    {r0, r1, lr}
    ldr     r0, =string_rsb
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_add:
    push    {r0, r1, lr}
    ldr     r0, =string_add
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_adc:
    push    {r0, r1, lr}
    ldr     r0, =string_adc
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_sbc:
    push    {r0, r1, lr}
    ldr     r0, =string_sbc
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_rsc:
    push    {r0, r1, lr}
    ldr     r0, =string_rsc
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_tst:
    push    {r0, r1, lr}
    ldr     r0, =string_tst
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_teq:
    push    {r0, r1, lr}
    ldr     r0, =string_teq
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_cmp:
    push    {r0, r1, lr}
    ldr     r0, =string_cmp
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_cmn:
    push    {r0, r1, lr}
    ldr     r0, =string_cmn
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_orr:
    push    {r0, r1, lr}
    ldr     r0, =string_orr
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_mov:
    push    {r0, r1, lr}
    ldr     r0, =string_mov
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_bic:
    push    {r0, r1, lr}
    ldr     r0, =string_bic
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_mvn:
    push    {r0, r1, lr}
    ldr     r0, =string_mvn
    mov     r1, r2
    bl      printf
    pop     {r0, r1, lr}
    bx      lr

is_branch:
    and     r5, r3, #0x00ffffff     @ 提取偏移值的binary code
    lsl     r5, r5, #2              @ 偏移值左移 2 位（word → byte

    lsl     r5, r5, #6              @ 符號擴展為 32-bit
    asr     r5, r5, #6
    
    add     r5, r5, r2              @ 計算目標 PC = 當前 PC + 偏移值
    add     r5, r5, #8              @ 加上流水線補償 

    @ output branch
    push    {r0, r1, r2, lr}
    ldr     r0, =string_branch
    mov     r1, r2
    mov     r2, r5
    bl      printf
    pop     {r0, r1, r2, lr}
    bx      lr


@ 停止程式
end_deasm:
    sub	    sp, fp, #4
	ldmfd	sp!, {r0, r1, fp, lr}          
    bx      lr 


@	string
string:
    .asciz	"%x\n"

string0:
	.asciz	"PC\tinstruction\n"

string_none:
    .asciz	"%d\t--\n"

string_and:
    .asciz	"%d\tAND\n"

string_eor:
    .asciz	"%d\tEOR\n"

string_sub:
    .asciz	"%d\tSUB\n"

string_rsb:
    .asciz	"%d\tRSB\n"

string_add:
    .asciz	"%d\tADD\n"

string_adc:
    .asciz	"%d\tADC\n"

string_sbc:
    .asciz	"%d\tSBC\n"

string_rsc:
    .asciz	"%d\tRSC\n"

string_tst:
    .asciz	"%d\tTST\n"

string_teq:
    .asciz	"%d\tTEQ\n"

string_cmn:
    .asciz	"%d\tCMN\n"

string_cmp:
    .asciz	"%d\tCMP\n"

string_orr:
    .asciz	"%d\tORR\n"

string_mov:
    .asciz	"%d\tMOV\n"

string_bic:
    .asciz	"%d\tBIC\n"

string_mvn:
    .asciz	"%d\tMVN\n"

string_branch:
    .asciz	"%d\tB\t%d\n"


Label1:
    .word   0x77777777
    .short  0x1122
    .byte   0x31, 0x32, 0x33, 0x34
    .end