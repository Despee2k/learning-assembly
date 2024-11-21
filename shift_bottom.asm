mov ds, 0b800h
mov dx, 25

main:
    mov si, 0

    declare:
        mov di, si
        add di, 3840
        mov al, b[ds:di]

        shift:
            mov cl, b[ds:di - 160]
            mov b[ds:di], cl

            sub di, 160

            cmp di, si
            jg shift

        mov b[ds:di], al

        add si, 2
        cmp si, 158
        jl declare

    mov cx, 0ffffh
    delay:
        loop delay

        dec dx
        cmp dx, 0
        jg main

int 20h