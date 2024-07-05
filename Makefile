#  --ignore-unresolved-symbol _GLOBAL_OFFSET_TABLE_

all: run

kernel.bin: kernel-entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel-entry.o: kernel-entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	gcc -fno-PIE -m32 -ffreestanding -c $< -o $@

mbr.bin: mbr.asm
	nasm $< -f bin -o $@

os.bin: mbr.bin kernel.bin
	cat $^ > $@

run: os.bin
	qemu-system-i386 -fda $<

clean:
	$(RM) *.bin *.o *.dis