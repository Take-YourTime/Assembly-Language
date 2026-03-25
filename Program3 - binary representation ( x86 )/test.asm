section .data
    prompt db "Enter an integer", 0xA,  0
    output db "You entered: ", 0
    newline db 0xA, 0
    buffer db 0, 0, 0, 0      ; Buffer to hold input

section .bss
    input resb 11             ; Buffer for user input

section .text
    global _start

_start:
    ; Display prompt
    mov rax, 4                ; sys_write
    mov rbx, 1                ; stdout
    mov rcx, prompt           ; address of prompt string
    mov rdx, 17               ; length of prompt
    int 0x80                  ; invoke system call

    ; Read input
    mov rax, 3                ; sys_read
    mov rbx, 0                ; stdin
    mov rcx, input            ; address of input buffer
    mov rdx, 11               ; max bytes to read
    int 0x80                  ; invoke system call

    ; Output "You entered: "
    mov rax, 4                ; sys_write
    mov rbx, 1                ; stdout
    mov rcx, output           ; address of output string
    mov rdx, 12               ; length of output
    int 0x80                  ; invoke system call

    ; Output the user's input
    mov rax, 4                ; sys_write
    mov rbx, 1                ; stdout
    mov rcx, input            ; address of input buffer
    mov rdx, 11               ; length of input buffer
    int 0x80                  ; invoke system call
    
    ; Print a newline
    mov rax, 4                ; sys_write
    mov rbx, 1                ; stdout
    mov rcx, newline          ; address of newline
    mov rdx, 1                ; length of newline
    int 0x80                  ; invoke system call
    
    
    ; Exit program
    mov rax, 1                ; sys_exit
    xor rbx, rbx              ; return code 0
    int 0x80                  ; invoke system call
