mov ds, 0b800h
mov dx, 80

main:
    mov si, 3840

    declare:
        mov di, si
        sub di, 158
        mov al, b[ds:di]

        shift:
            mov cl, b[ds:di + 2]    ; Copy the character from two positions earlier to the current position
            mov b[ds:di], cl        ; Place the shifted character into the current position

            add di, 2

            cmp di, si
            jl shift

        mov b[ds:di], al            ; Place the saved character in the first position

        sub si, 160
        cmp si, 0
        jg declare

    mov cx, 0ffffh
    delay:
        loop delay

        dec dx
        cmp dx, 0
        jg main

int 20h