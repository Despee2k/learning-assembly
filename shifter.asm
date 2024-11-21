; Set up the video memory segment (0xB8000 is the address of the video buffer in text mode)
mov ds, 0b800h

; Set the number of iterations (80 times)
; mov dx, 80

; Main loop to repeat the shift operation 80 times
reset:
    mov si, 0               ; Start from the first row (top of the screen)

    ; Process all rows on the screen (25 rows, 80 columns per row)
    init:
        mov di, si          ; Copy row start address (si points to the start of the current row)
        add di, 158         ; Move di to the last character of the current row (80*2 = 160 bytes, so 160-2 = 158 offset)

        ; Save the last character of the current row
        mov al, b[ds:di]

        ; Shift all characters to the left by 1 position
    shift:
        ; Copy the character from two positions earlier to the current position
        mov cl, b[ds:di - 2]
        mov b[ds:di], cl     ; Place the shifted character into the current position

        ; Move di back to the previous character
        sub di, 2

        ; Check if we have reached the start of the row
        cmp di, si
        jg shift             ; If not, continue shifting

        ; After shifting, place the last character at the start of the row
        mov b[ds:di], al     ; Place the saved character in the first position

        ; Move to the next row (advance by 160 bytes: 80 characters * 2 bytes per character)
        add si, 160

        ; Check if we've processed all rows (25 rows * 160 bytes = 4000 bytes)
        cmp si, 4000
        jl init              ; If not, process the next row

    ; Add a small delay to prevent flickering
    mov cx, 0ffffh          ; Set up a counter for delay

    delay_loop:
        loop delay_loop     ; Loop to create delay

    ; Decrease dx (for repeating the process 80 times)
        ; dec dx
        ; cmp dx, 0
        ; jg reset               ; If dx > 0, repeat the process again

int 20h