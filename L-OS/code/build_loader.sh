echo "start build loader ..."
NAME="loader"
nasm -o ../bin/$NAME.bin ./boot/$NAME.S -I ./include/
dd if=../bin/$NAME.bin of=$HOME/study/Operating-System-Truth-Restoration/L-OS/hd60M.img bs=512 count=2 conv=notrunc seek=2
echo "finish ..."
