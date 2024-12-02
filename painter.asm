org 100h

newline db 0Dh, 0Ah, '$'
inputMsg db "Choose color: [1] RED, [2] GREEN, [3] BLUE $"
redColor db 04h
greenColor db 02h
blueColor db 01h
screenWidth db 80
screenHeight db 25

start:
  mov ax, 0003h
  int 10h

  mov ax, 0000h
  int 33h

mainLoop:
  lea dx, newline
  mov ah, 09h
  int 21h

  lea dx, inputMsg
  mov ah, 09h
  int 21h

getInput:
  mov ah, 01h
  int 21h
  cmp al, 1Bh
  je exit

  cmp al, '1'
  je selectRed
  cmp al, '2'
  je selectGreen
  cmp al, '3'
  je selectBlue
  jmp mainLoop

selectRed:
  mov bl, redColor
  call mousePaint
  jmp mainLoop

selectGreen:
  mov bl, greenColor
  call mousePaint
  jmp mainLoop

selectBlue:
  mov bl, blueColor
  call mousePaint
  jmp mainLoop

mousePaint:
  mov ax, 0001h
  int 33h

paintLoop:
  mov ax, 0003h
  int 33h

  test bx, 1
  jz paintLoop

  mov ax, cx
  mov di, ax
  mov ax, dx
  mov si, ax

  cmp di, 80
  jl validCoordX
  mov di, 79
validCoordX:

  cmp si, 25
  jl validCoordY
  mov si, 24
validCoordY:

  mov ax, 0000h
  int 33h

  mov ax, si
  mov bx, 80
  mul bx
  add di, ax

  shl di, 1
  add di, 1

  mov al, bl
  mov es, 0B800h
  mov [es:di], al

  jmp mainLoop

exit:
  mov ax, 0003h
  int 10h
  int 20h