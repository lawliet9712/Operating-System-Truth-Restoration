$HOME/local/bin/gcc -m32  -fno-stack-protector -c -o kernel/main.o kernel/main.c
# 设定地址为内核空间 0x1500
ld -m elf_i386 kernel/main.o -Ttext 0xc0001500 -e main -o kernel/kernel.bin
# 写入到硬盘, 第 9  个扇区写入,一次性写入 200, 这样后续 kernel 变大也不用怎么调整
dd if=kernel/kernel.bin of=$HOME/study/Operating-System-Truth-Restoration/L-OS/hd60M.img bs=512 count=200 seek=9 conv=notrunc
