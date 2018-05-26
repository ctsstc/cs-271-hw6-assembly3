section .text
global start                ; for linker

start:                      ; label

exit:
mov eax, 1                  ; syscall #1 - Exit?
mov ebx, 0                  ; exit code? 0
int 0x80                    ; invoke dispatcher

;;; Variables
section .data
BUFFER_SIZE: equ 1024       ; declare constant
helloMessage: db "Enter a sequence of redundant characters and the hampsters will run length encode them", 10, ">> "
helloMessageSize: equ $ - helloMessage

section .bss
inputBuffer: resb BUFFER_SIZE   ; declare inputBuffer of BUFFER_SIZE bytes
stringBuilder: resb BUFFER_SIZE ; decalre stringBuilder of BUFFER_SIZE bytes