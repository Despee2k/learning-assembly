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

            sub di, 2

            cmp di, si
            jg shift

        mov b[ds:di], al            ; Place the saved character in the first position

        add si, 320
        cmp si, 4000
        jl declare

    mov cx, 0ffffh
    delay:
        loop delay

        dec dx
        cmp dx, 0
        jg main

int 20h