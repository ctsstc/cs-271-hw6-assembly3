section .text
global start                    ; for linker

start:                          ; label

push helloMessage               ; First Param
push helloMessageSize           ; Second Parameter
call writeMessage               ; Call function

push inputBuffer
push BUFFER_SIZE
call getInput

jmp repeatSetup


jmp exit                        ; Nice safty


;;;;; Meat ;;;;;;;;;;;;;;;
;;; eax     = i
;;; ebx     = keyCount
;;; ecx     = count
;;; dl      = current character
;;; dh      = lastChar
;;;;;;;;;;;;;;;;;;;;;;;;;;

; clear and establish "variables"/registers
repeatSetup:
xor eax, eax
xor ebx, ebx
xor ecx, ecx

repeat:
mov dl, [inputBuffer + eax]     ; current char = next char
inc eax                         ; i++
cmp dl, 0xa                     ; if current char == EOL; end of line character
je writeEncoded                 ;   true ==> writeEncoded

; if count == 0
cmp ecx, 0                          ; count == 0
jne isCurrentChar                   ;   false ==> isCurrentChar
mov dh, dl                          ; last char = current char
mov [stringBuilder + ebx * 2], dl   ; string builder[keyCount * 2] += current char
inc ebx                             ; keyCount ++
inc ecx                             ; count ++
jmp repeat                          ; repeat

; if last char == current char 
isCurrentChar:
cmp dh, dl                      ; last char == current char
jne appendCount                 ;   false ==> appendCount
inc ecx                         ; count ++
jmp repeat                      ; repeat

; else
appendCount:
add ecx, '0'                            ; count to string
mov [stringBuilder + ebx * 2 + 1], ecx  ; string builder[keyCount * 2 + 1] += count
xor ecx, ecx                            ; count = 0
jmp repeat                              ; repeat

;;;;; "Functions" n Stuff ;;;;;

getInput:
mov eax, 3                  ; syscall 3 - read
mov ebx, 0                  ; std in
mov ecx, [esp+8]            ; first param; buffer to read into
mov edx, [esp+4]            ; second para; number of bytes to read
int 0x80                    ; invoke dispatcher
ret

writeMessage:
mov eax, 4                  ; syscall #4 - write
mov ebx, 1                  ; std out
mov ecx, [esp+8]            ; buffer = first parameter
mov edx, [esp+4]            ; size = second parameter
int 0x80                    ; invoke dispatcher
ret

writeEncoded:
push stringBuilder          ; push stringBuilder pointer
sal ebx, 1                  ; key count *= 2
push ebx                    ; push string Builder Length
call writeMessage
jmp exit

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
