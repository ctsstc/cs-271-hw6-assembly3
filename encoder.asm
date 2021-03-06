section .text
global start                    ; for linker

start:                          ; label

push helloMessage               ; First Param
push helloMessageSize           ; Second Parameter
call writeMessage               ; Call function

push inputBuffer
push BUFFER_SIZE
call getInput

jmp setupRepeat


;;;;; Meat ;;;;;;;;;;;;;;;
;;; eax     = i
;;; ebx     = keyCount
;;; ecx     = count
;;; dl      = current character
;;; dh      = lastChar
;;;;;;;;;;;;;;;;;;;;;;;;;;

; clear and establish "variables"/registers
setupRepeat:
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

repeat:
mov dl, [inputBuffer + eax]     ; current char = inputBuffer[i]
inc eax                         ; i++
inc ecx                         ; count ++

; if current char == EOL
cmp dl, 0xa                     ; if current char == EOL; end of line character
je wrapUp                       ;   true ==> wrapUp

; if last char == current char 
cmp dh, dl                      ; last char == current char
jne newCharacter                ;   false ==> newCharacter
jmp repeat                      ; repeat

; else
newCharacter:

; if i == 1
cmp eax, 1                      ; if i  == 1; first character
je addCharacter                 ;   true ==> addCharacter; skip count concat

; Concatenate Count
add ecx, '0'                                ; count to string
mov [stringBuilder + (ebx-1) * 2 + 1], ecx  ; string builder[(keyCount-1) * 2 - 1] += count

addCharacter:
mov [stringBuilder + ebx * 2], dl       ; string builder[keyCount * 2] += current char
xor ecx, ecx                            ; count = 0
inc ebx                                 ; keyCount ++
mov dh, dl                              ; last char = current char
jmp repeat                              ; repeat

; Concat last count to string builder
wrapUp:
add ecx, '0'                            ; count to string
mov [stringBuilder + ebx * 2 - 1], ecx  ; string builder[keyCount * 2 - 1] += count
mov ecx, 0xa                            ; New Line Character
mov [stringBuilder + ebx * 2], ecx      ; string builder += EOL Character

writeEncoded:
push stringBuilder          ; push stringBuilder pointer
sal ebx, 1                  ; key count *= 2
inc ebx                     ; string builder length + 1 (for EOL character)
push ebx                    ; push string Builder Length
call writeMessage
jmp exit

exit:
mov eax, 1                  ; syscall #1 - Exit?
mov ebx, 0                  ; exit code? 0
int 0x80                    ; invoke dispatcher

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

;;; Variables
section .data
BUFFER_SIZE: equ 1024       ; declare constant
helloMessage: db "Enter a sequence of redundant characters and the hampsters will run length encode them", 10, ">> "
helloMessageSize: equ $ - helloMessage

section .bss
inputBuffer: resb BUFFER_SIZE   ; declare inputBuffer of BUFFER_SIZE bytes
stringBuilder: resb BUFFER_SIZE ; decalre stringBuilder of BUFFER_SIZE bytes
