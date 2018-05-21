section .text
global start               ; for linker

start:                     ; label

pushad                      ; Save registers
push helloMessage           ; First Param
push helloMessageSize       ; Second Parameter
call writeMessage           ; Call function
popad                       ; cleanup

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
mov ecx, [esp+8]            ; buffer = first parameter
mov edx, [esp+4]            ; size = second parameter
int 0x80                    ; invoke dispatcher
ret

exit:
mov eax, 1                  ; syscall #1 - Exit?
mov ebx, 0                  ; exit code? 0
int 0x80                    ; invoke dispatcher

;;; Variables
section .data
BUFFER_SIZE: equ 1024    ; declare constant
helloMessage: db "Enter a sequence of redundant characters and the hampsters will run length encode them", 10, ">> "
helloMessageSize: equ $ - helloMessage

section .bss
inputBuffer: resb BUFFER_SIZE   ; declare inputBuffer of SIZE bytes
