echo "start build mbr ..."
nasm -o ../bin/mbr.bin ./boot/mbr.S -I ./include/
dd if=../bin/mbr.bin of=$HOME/study/Operating-System-Truth-Restoration/L-OS/hd60M.img bs=512 count=1 conv=notrunc
echo "finish ..."
