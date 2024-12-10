call display_msg1         ; Display message for the first digit
call input
mov bx, ax                ; Save the first number

call display_msg2         ; Display message for the second digit
call input                ; Second number is already in ax

add ax, bx                ; Add the two numbers
call print

int 20h

msg1 db "Enter first digit: $"
msg2 db 0Dh, 0Ah, "Enter second digit: $"

display_msg1:
    mov dx, offset msg1    ; Load the address of msg1 into dx
    mov ah, 09h            ; DOS interrupt to display a string
    int 21h
    ret
display_msg2:
    mov dx, offset msg2    ; Load the address of msg2 into dx
    mov ah, 09h            ; DOS interrupt to display a string
    int 21h
    ret

; READ SECTION
input:
    push bx
    mov ax, 0
    mov bx, 0
input_loop:
    mov ah, 01h             ; Wait for a key to be pressed
    int 21h                 ; Call the interrupt to get the character
    cmp al, 0Dh             ; If the user presses enter, we are done reading 0Dh is `\r` in ASCII
    je done
    imul bx, 10             ; Simple number manipulation, simply adding offset for the new digit
    and ax, 0Fh             ; Masking the lower 4 bits, since we are reading a single digit at a time
    add bx, ax
    jmp input_loop
done: 
    mov ax, bx              ; Return the number to ax register, it's common to use ax register since it is the accumulator
    pop bx
    ret

; PRINT SECTION
print:
    xor cx, cx
    cmp ax, 0
    jne print_loop          ; If the number is not 0, print the digit else print 0
    mov dx, '0'
    push dx
    inc cx
    jmp print_digits
print_loop:
    xor dx, dx
    mov bx, 10              ; Dividing by 10 to get the digits
    div bx                  ; Dividing ax by bx, quotient in ax and remainder in dx
    add dx, '0'             ; Convert the digit to ASCII
    push dx                 ; Push the digit to the stack
    inc cx                  ; Seems like it's not necessary, but it's being used to loop through the digits
    test ax, ax             ; This is similar to cmp ax, 0, cmp is an arithmetic operation, test is a logical operation
    jnz print_loop
print_digits:
    pop dx                  ; Pop the digit from the stack
    mov ah, 02h             ; DOS interrupt to print the character, register dl will be used here, that is why we are storing the register dx
    int 21h                 ; Call the interrupt
    loop print_digits       ; Where register cx is being used, we could just simply check if sp (stack) is empty, but why bother
    ret