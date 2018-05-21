section .text
global start               ; for linker

start:                     ; label
call getInput
call getInput
jmp exit

getInput:
mov eax, 3                  ; syscall 3 - read
mov ebx, 0                  ; std in
mov ecx, inputBuffer        ; buffer to read into
mov edx, BUFFER_SIZE        ; number of bytes to read
int 0x80                    ; invoke dispatcher
ret

writeMessage:
mov eax, 4                  ; syscall #4 - write
mov ebx, 1                  ; std out
pop ecx                     ; buffer out
pop edx                     ; buffer size
int 0x80                    ; invoke dispatcher
ret

exit:
mov eax, 1                  ; syscall #1 - Exit?
mov ebx, 0                  ; exit code? 0
int 0x80                    ; invoke dispatcher

;;; Variables
section .data
BUFFER_SIZE: equ 1024    ; declare constant

section .bss
inputBuffer: resb BUFFER_SIZE   ; declare inputBuffer of SIZE bytes
