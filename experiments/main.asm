section .text
global start                ; for linker
extern exit

start:                      ; label

call exit

section .text
msg: db "Hello World!"
len: eq $ - msg