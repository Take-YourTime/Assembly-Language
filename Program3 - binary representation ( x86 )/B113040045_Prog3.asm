section .data
    prompt db "Enter a number: ", 0xA, 0
    output db "The IEEE 754 representation of ", 0
    output2 db " is ", 0
    newline db 0xA, 0
    buffer db 0, 0, 0, 0      ; Buffer to hold input

section .bss
    input resb 11             ; Buffer for user input
    result resb 34            ; Buffer for result output (32 bits + null terminator)

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, prompt           ; address of prompt string
    mov edx, 17               ; length of prompt
    int 0x80                  ; invoke system call

    ; Output "IEEE 754 binary: "
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, output           ; address of output string
    mov edx, 31               ; length of output
    int 0x80                  ; invoke system call
    
    ; Read input
    mov eax, 3                ; sys_read
    mov ebx, 0                ; stdin
    mov ecx, input            ; address of input buffer
    mov edx, 11               ; max bytes to read
    int 0x80                  ; invoke system call

    ; Calculate the length of the input string
    xor rcx, rcx              ; Clear rcx, will hold the length
calculate_length:
    mov al, byte [input + rcx] ; Load current byte from input
    cmp al, 0x0A              ; Check for newline character
    je length_found           ; If newline, end of string
    cmp al, 0                 ; Check for null terminator
    je length_found           ; If null, end of string
    inc rcx                   ; Increment counter
    jmp calculate_length      ; Repeat for the next byte

length_found:
    mov edx, ecx              ; Store the string length in edx

    ; Output user input
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, input            ; address of input buffer
    int 0x80                  ; invoke system call

    ; Output "is"
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, output2          ; address of "is"
    mov edx, 4                ; length of "is"
    int 0x80                  ; invoke system call
    

    ; Convert input string to integer (assuming valid input)
    xor rax, rax              ; Clear rax, will hold the result
    xor rcx, rcx              ; Clear rcx, index for input buffer
convert_loop:
    movzx rdx, byte [input + rcx]   ; Load byte from input buffer
    test dl, dl              ; Check if it's the null terminator
    jz convert_done          ; If null terminator, we are done
    sub dl, '0'              ; Convert ASCII to integer (subtract '0')
    imul rax, rax, 10        ; Multiply current result by 10
    add rax, rdx             ; Add current digit
    inc rcx                  ; Move to next character in input
    jmp convert_loop         ; Repeat the loop

convert_done:
    ; Convert integer to IEEE 754 binary format
    push rax                 ; Push the number onto the stack
    fild qword [rsp]         ; Load integer as double into FPU
    sub rsp, 4               ; Allocate space for single precision result
    fstp dword [rsp]         ; Store result as single precision float
    mov eax, [rsp]           ; Load 32-bit float representation into eax
    add rsp, 12              ; Clean up stack

    ; Convert the 32-bit IEEE 754 value to binary string
    mov rcx, 32              ; Bit length to process (32 bits)
    lea rbx, [result]        ; Point to the result buffer

convert_to_binary:
    shl eax, 1               ; Shift left by 1 (move the next bit to carry)
    jc store_one             ; If carry is set, the bit is 1
    mov byte [rbx], '0'      ; Else, store '0'
    jmp next_bit

store_one:
    mov byte [rbx], '1'      ; Store '1' for this bit

next_bit:
    inc rbx                  ; Move to next character in result buffer
    dec rcx                  ; Decrease the bit counter
    jnz convert_to_binary    ; Repeat until all bits are processed

    ; Null-terminate the string
    mov byte [rbx], 0

    ; Output the result (binary format)
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    lea ecx, [result]         ; address of result string
    mov edx, 33               ; length of result string (32 bits + null terminator)
    int 0x80                  ; invoke system call

    ; Print a newline
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, newline          ; address of newline
    mov edx, 1                ; length of newline
    int 0x80                  ; invoke system call

    ; Exit program
    mov eax, 1                ; sys_exit
    xor ebx, ebx              ; return code 0
    int 0x80                  ; invoke system call