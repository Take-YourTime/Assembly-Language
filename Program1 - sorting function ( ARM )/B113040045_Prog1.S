@the information that tells arm-none-eabi-as what arch. to assemble to 
	.cpu arm926ej-s
	.fpu softvfp
@this is code section
	
@note, we must have the main function for the simulator's linker script
	.text
	.align	2   @align 4 byte
	.global	main

main:
    @ prologue
	stmfd	sp!, {r0, r1, fp, lr}	@ 命令列呼叫 → r0 = argc, r1 = argv
	add	fp, sp, #4
@@@
    @ code body

	@ skip program name
	sub r0, r0, #1	@ argc--
	add r1, r1, #4	@ skip the file name in argv[]


	@ convert argv[] into integer
	mov r2, #0		@ index = 0
	mov r4, #0		@ number
	ldr r7, =arr	@ r7 = arr

FOR_LOOP:
	cmp r2, r0				@ index < argc?
	bge END_FOR					@ index >= argc, end loop
	ldr r3, [r1, r2, lsl #2]@ load the string into r3

DIGIT:
	ldrb r5, [r3], #1		@ load the character of sting(r3) into r5 
	cmp r5, #0      		@ the character == NULL?
	beq PUSH_ARRAY				@ If yes, finsih convert current string into integer. Push r4 into array

	add	r4, r4, r4, lsl #2	@ number = number * 5
	add r4, r4, r4  		@ number *= 10
	sub r5, r5, #'0'		@ number += argv[index] - '0'
	add r4, r4, r5			
	b DIGIT

PUSH_ARRAY:
	str r4, [r7, r2, lsl #2]@ push number into array
	add r2, r2, #1			@ index++
	mov r4, #0				@ number reset to 0
	b FOR_LOOP
END_FOR:



	@ bubble sort
	mov r2, #0		@ index
					@ r7 = arr
SORT:
	cmp r2, r0		@ index < argc-1?
	bge END_SORT		@ if no, end sort
	mov r3, #0		@ index2 = 0
	sub r4, r0, r2	@ index2 range = argc-1 - index - 1
	sub r4, r4, #1
	
FOR_SORT:
	cmp r3, r4					@ index2 < argc-1 - index - 1?
	bge END_FOR_SORT				@ if no, end sort
	ldr r5, [r7, r3, lsl #2]	@ r5 = array[index2]
	add r3, r3, #1				@ index2++			
	ldr r6, [r7, r3, lsl #2]	@ r6 = array[index2+1]

	cmp r5, r6					@ array[index2] < array[index2+1]?
	bge FOR_SORT					@ if no, swap
	str r5, [r7, r3, lsl #2]    @ store r5 into array[index2+1]
	sub r3, r3, #1              @ revert (index2--)
	str r6, [r7, r3, lsl #2]    @ store r6 into array[index2]
	add r3, r3, #1              @ index2++
	b FOR_SORT
	
END_FOR_SORT:
	add r2, r2, #1	@ index++
	b SORT
END_SORT:


	@ output
	push {r0}
	ldr r0, =string0
    bl  printf
	pop	{r0}


	@ output sorting result
	mov r2, #0		@ index
Label:
	cmp r2, r0		@ index < argc-1?
	bge END_LABEL
		
	push {r0, r1, r2}
	ldr r0, =string1
	ldr r1, [r7, r2, lsl #2]
    bl  printf 
	pop	{r0, r1, r2}
	
	add r2, r2, #1
	b Label
END_LABEL:
@@@	
	@epilogue
	sub	sp, fp, #4
	ldmfd	sp!, {r0,r1,fp, lr}
	bx	lr


@	array
arr:	.word 0, 0, 0, 0, 0, 0, 0, 0

@	string
string0:
	.asciz	"Sorting result is:"

string1:
	.asciz	" %d"


Label1:
    .word   0x77777777
    .short  0x1122
    .align 2
    .byte   0x31, 0x32, 0x33, 0x34
    .end