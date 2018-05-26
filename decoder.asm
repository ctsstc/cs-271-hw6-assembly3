section .text
global start                ; for linker

start:                      ; label

push helloMessage               ; First Param
push helloMessageSize           ; Second Parameter
call writeMessage               ; Call function

push inputBuffer
push BUFFER_SIZE
call getInput

jmp setupRepeat

;;;;; Meat ;;;;;;;;;;;;;;;
;;; eax     = i
;;; ebx     = stringBuilderPos
;;; cl      = ii
;;; ch      = currentCharacter
;;; dl      = characterCount
;;;;;;;;;;;;;;;;;;;;;;;;;;

; clear and establish "variables"/registers
setupRepeat:
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

mov ebx, 0

repeat:
mov ch, [inputBuffer + eax]     ; currentCharacter = inputBuffer[i]
mov dl, [inputBuffer + eax + 1] ; characterCount = inputBuffer[i+1]
sub dl, 0x30                    ; characterCount to int (from string)

; if currentCharacter == EOL
cmp ch, 0xa                     ; currentCharacter == EOL
je writeDecoded                 ;   true ==> writeDecoded

characterLoop:
mov [stringBuilder + ebx], ch   ; stringBuilder[stringerBuilderPos] = currentCharacter
inc ebx                         ; stringBuilderPos ++
inc cl                          ; ii ++
cmp cl, dl                      ; ii == characterCount
jne characterLoop               ;   false ==> characterLoop
add al, 2                       ; i += 2
xor cl, cl                      ; ii = 0
jmp repeat

writeDecoded:
mov ch, 0xa                     ; EOL; New Line Character
mov [stringBuilder + ebx], ch   ; string builder += EOL Character
inc ebx                         ; stringBuilderPos ++ ; for EOL character
push stringBuilder              ; push stringBuilder pointer
push ebx                        ; push string Builder Length
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
helloMessage: db "Enter a run length encodeded string and the wallabies will expand it.", 10, ">> "
helloMessageSize: equ $ - helloMessage

section .bss
inputBuffer: resb BUFFER_SIZE   ; declare inputBuffer of BUFFER_SIZE bytes
stringBuilder: resb BUFFER_SIZE ; decalre stringBuilder of BUFFER_SIZE bytes