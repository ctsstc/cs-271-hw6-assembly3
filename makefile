all: hw6

hw6.o: hw6.asm
	nasm -f elf32 -g -F stabs hw6.asm
	
hw6: hw6.o
	ld -e start -m elf_i386 -o hw6 hw6.o


rebuild: b

a: hw6.asm
	nasm -f elf32 -g -F stabs hw6.asm
	
b: a
	ld -e start -m elf_i386 -o hw6 hw6.o


clean:
	rm *.o hw6