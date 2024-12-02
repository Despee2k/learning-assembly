org 100h

newline db 0Dh, 0Ah, '$'
inputMsg db "Choose background color: [1] RED, [2] GREEN, [3] BLUE $"
bgRed db 40h
bgGreen db 20h
bgBlue db 10h

start:
  lea dx, newline
  mov ah, 09h
  int 21h

  lea dx, inputMsg
  mov ah, 09h
  int 21h

waitForInput:
  mov ah, 00h
  int 16h

  cmp al, 1Bh
  je exit

  cmp al, '1'
  je fillRed
  cmp al, '2'
  je fillGreen
  cmp al, '3'
  je fillBlue

  jmp start

fillRed:
  mov al, bgRed
  call fillScreen
  jmp start

fillGreen:
  mov al, bgGreen
  call fillScreen
  jmp start

fillBlue:
  mov al, bgBlue
  call fillScreen
  jmp start

fillScreen:
  mov di, 0B800h
  mov es, di
  xor di, di
  mov cx, 2000
.fillLoop:
  mov ah, es:[di+1]
  and ah, 0Fh
  or ah, al
  mov es:[di+1], ah
  add di, 2
  loop .fillLoop
  ret

exit:
  mov ah, 4Ch
  int 21h