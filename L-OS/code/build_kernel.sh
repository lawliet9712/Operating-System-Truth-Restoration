nasm -f elf -o build/print.o lib/kernel/print.S
nasm -f elf -o build/kernel.o kernel/kernel.S
$HOME/local/bin/gcc -I lib/kernel/ -fno-builtin -m32 -fno-stack-protector -c -o build/timer.o device/timer.c
$HOME/local/bin/gcc -I lib/kernel/ -I kernel/ -I lib/ -fno-builtin -m32 -fno-stack-protector -c -o build/main.o kernel/main.c
$HOME/local/bin/gcc -I lib/kernel/ -I kernel/ -I lib/ -fno-builtin -m32 -fno-stack-protector -c -o build/interrupt.o kernel/interrupt.c
$HOME/local/bin/gcc -I lib/kernel/ -I kernel/ -I lib/ -fno-builtin -m32 -fno-stack-protector -c -o build/init.o kernel/init.c
# 设定地址为内核空间 0x1500
ld -m elf_i386 -Ttext 0xc0001500 -e main -o build/kernel.bin build/main.o build/init.o build/interrupt.o build/print.o build/kernel.o build/timer.o
# 写入到硬盘, 第 9  个扇区写入,一次性写入 200, 这样后续 kernel 变大也不用怎么调整
dd if=build/kernel.bin of=$HOME/study/Operating-System-Truth-Restoration/L-OS/hd60M.img bs=512 count=200 seek=9 conv=notrunc
