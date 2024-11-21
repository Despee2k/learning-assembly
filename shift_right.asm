mov ds, 0b800h
mov dx, 80

main:
    mov si, 0

    declare:
        mov di, si
        add di, 158
        mov al, b[ds:di]

        shift:
            mov cl, b[ds:di - 2]
            mov b[ds:di], cl

            sub di, 2

            cmp di, si
            jg shift

        mov b[ds:di], al

        add si, 160
        cmp si, 4000
        jl declare

    mov cx, 0ffffh
    delay:
        loop delay

        dec dx
        cmp dx, 0
        jg main

int 20h