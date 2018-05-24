all: main

main.o: main.asm
	nasm -f elf32 -g -F stabs main.asm

exit.o: exit.asm
	nasm -f elf32 -g -F stabs exit.asm
	
main: main.o exit.o
	ld -e start -m elf_i386 -o main main.o exit.o

clean:
	rm *.o main