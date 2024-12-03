org 100h

newline db 0Dh, 0Ah, '$'
inputMsg db "Choose color: [1] RED, [2] GREEN, [3] BLUE $"
redColor db 40h          ; Background red (bit-shifted to the upper nibble)
greenColor db 20h        ; Background green
blueColor db 10h         ; Background blue
screenWidth db 80
screenHeight db 25

start:
  mov ax, 0003h          ; Set text mode
  int 10h

  mov ax, 0000h          ; Initialize mouse
  int 33h

mainLoop:
  lea dx, newline        ; Print a newline
  mov ah, 09h
  int 21h

  lea dx, inputMsg       ; Display the input message
  mov ah, 09h
  int 21h

getInput:
  mov ah, 01h            ; Wait for key input
  int 21h
  cmp al, 1Bh            ; If ESC is pressed, exit
  je exit

  cmp al, '1'            ; Check for color selection
  je selectRed
  cmp al, '2'
  je selectGreen
  cmp al, '3'
  je selectBlue
  jmp mainLoop

selectRed:
  mov bh, redColor       ; Set color to red
  call mousePaint
  jmp mainLoop

selectGreen:
  mov bh, greenColor     ; Set color to green
  call mousePaint
  jmp mainLoop

selectBlue:
  mov bh, blueColor      ; Set color to blue
  call mousePaint
  jmp mainLoop

mousePaint:
  push bx
  mov ax, 0001h          ; Show mouse cursor
  int 33h

paintLoop:
  mov ax, 0003h          ; Get mouse position and button status
  int 33h

  test bx, 1             ; Check if left mouse button is clicked
  jz paintLoop

  mov ax, cx             ; Get mouse X position
  shr ax, 3              ; Divide by 8 (convert pixel to character position)
  mov di, ax             ; DI = X

  mov ax, dx             ; Get mouse Y position
  shr ax, 3              ; Divide by 8 (convert pixel to character position)
  mov si, ax             ; SI = Y

  cmp di, 80             ; Bound X coordinate to screen width
  jl validCoordX
  mov di, 79

validCoordX:

  cmp si, 25             ; Bound Y coordinate to screen height
  jl validCoordY
  mov si, 24

validCoordY:

  mov ax, si             ; Calculate screen buffer offset
  mov bx, 80             ; Screen width
  mul bx
  add di, ax
  shl di, 1              ; Convert to byte offset (character and attribute pair)

  mov es, 0B800h         ; Set ES to video memory segment

  mov ah, es:[di+1]      ; Read current attribute byte
  and ah, 0Fh            ; Clear upper nibble (background color)
  ;or ah, bl              ; Combine with new background color from bl
  pop bx
  mov es:[di+1], bh      ; Write updated attribute byte

  jmp mainLoop

exit:
  ; Exit without resetting screen or clearing video memory
  mov ah, 4Ch            ; Terminate program and return control to DOS
  int 21h