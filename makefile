all: encoder decoder

encoder.o: encoder.asm
	nasm -f elf32 -g -F stabs encoder.asm
	
encoder: encoder.o
	ld -e start -m elf_i386 -o encoder encoder.o

decoder.o: decoder.asm
	nasm -f elf32 -g -F stabs decoder.asm
	
decoder: decoder.o
	ld -e start -m elf_i386 -o decoder decoder.o


clean:
	rm *.o encoder decoder