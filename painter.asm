org 100h

newline db 0Dh, 0Ah, '$'
inputMsg db "Choose color: [1] RED, [2] GREEN, [3] BLUE $"
test1 db "RED $"
test2 db "GREEN $"
test3 db "BLUE $"

start:
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
  je printRed
  cmp al, '2'
  je printGreen
  cmp al, '3'
  je printBlue
  jmp start

printRed:
  lea dx, test1
  mov ah, 09h
  int 21h
  jmp start

printGreen:
  lea dx, test2
  mov ah, 09h
  int 21h
  jmp start

printBlue:
  lea dx, test3
  mov ah, 09h
  int 21h
  jmp start

exit:
  int 20h