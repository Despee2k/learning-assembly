mov ds, 0b800h
mov dx, 80

main:
    mov si, 0

    declare:
        mov di, si
        add di, 158
        mov al, b[ds:di]

    shift:
        mov cl, b[ds:di - 2]    ; Copy the character from two positions earlier to the current position
        mov b[ds:di], cl        ; Place the shifted character into the current position

        sub di, 2               ; Move di back to the previous character

        cmp di, si              ; Check if we have reached the start of the row
        jg shift

                                ; After shifting, place the last character at the start of the row
        mov b[ds:di], al        ; Place the saved character in the first position

        add si, 160

        cmp si, 4000
        jl declare

    mov cx, 0ffffh
    delay_loop:
        loop delay_loop

        dec dx
        cmp dx, 0
        jg main

int 20h
