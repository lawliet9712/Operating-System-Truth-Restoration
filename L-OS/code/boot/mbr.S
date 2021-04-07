%include "boot.inc"
SECTION MBR vstart=0x7c00         
   mov ax,cs      
   mov ds,ax
   mov es,ax
   mov ss,ax
   mov fs,ax
   mov sp,0x7c00
   mov ax,0xb800
   mov gs,ax

   mov     ax, 0x600
   mov     bx, 0x700
   mov     cx, 0    
   mov     dx, 0x184f
   int     0x10

   mov byte [gs:0x00],'1'
   mov byte [gs:0x01],0xA4

   mov byte [gs:0x02],' '
   mov byte [gs:0x03],0xA4

   mov byte [gs:0x04],'M'
   mov byte [gs:0x05],0xA4

   mov byte [gs:0x06],'B'
   mov byte [gs:0x07],0xA4

   mov byte [gs:0x08],'R'
   mov byte [gs:0x09],0xA4

   mov eax, LOADER_START_SECTOR ; 扇区 lba 地址
   mov bx, LOADER_BASE_ADDR ; 写入的地址
   mov cx, 1                ; 读的扇区数量
   call rd_disk_m_16

   jmp LOADER_BASE_ADDR

; 读取硬盘 n 个扇区
rd_disk_m_16:
   mov esi, eax
   mov di, cx

; step 1 : 设置要读取的扇区数量
   mov dx, 0x1f2
   mov al, cl
   out dx, al ; 读取的扇区数量

   mov eax, esi ; 恢复 ax
; step 2 : 将 LBA 地址存到 0x1f3 ~ 0x1f6 端口
; 0 ~ 7 位写入 0x1f3
   mov dx, 0x1f3
   out dx, al
; 8 ~ 15 写入 0x1f4
   mov cl, 8
   shr eax, cl
   mov dx, 0x1f4
   out dx, al
; 16 ~ 23 写入 0x1f5
   shr eax, cl
   mov dx, 0x1f5
   out dx, al

; 24 ~ 27 写入 0x1f6
   shr eax, cl
   and al, 0x0f ; 24 ~ 27 位， & 做掩码
   or al, 0xe0  ; 设置 4 ~ 7 位 1110，表示 lba 模式
   mov dx, 0x1f6
   out dx, al

; step 3 : 0x1f7 端口写入读命令 0x20
   mov dx, 0x1f7
   mov al, 0x20
   out dx, al

; step 4 : 检查硬盘状态
.not_ready:
   ; 同一端口，写时表示写入命令字，读时表示读入硬盘状态
   nop
   in al, dx
   and al, 0x88 ; 第 4 位为 1 表示硬盘已经准备好数据传输
                ; 第 7 位为 1 时表示硬盘忙
   cmp al, 0x08 ; 检查是否已经准备好
   jnz .not_ready ; 不相等，表示还没准备好

; step 5 : 从 0x1f0 端口读数据
   mov ax, di ; 几个扇区
   mov dx, 256
   mul dx ; mul 乘数是 dx, 而被乘数隐含在 al 或 ax 中，故此处为 dx * di
   mov cx, ax
   ; di=要读取的扇区数， 一个扇区 512 字节，每次读入一个字 ( 1word = 2byte )
   ; 总共需要 di * 512 / 2 次，故 di * 256
   mov dx, 0x1f0
.go_on_read:
   in ax, dx
   mov [bx], ax
   add bx, 2
   loop .go_on_read
   ret

   times 510-($-$$) db 0
   db 0x55,0xaa
