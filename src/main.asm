[org 0x7c00]
bits 16

jmp main

print:
    mov ah, 0x0e        ; enable teletype mode
    int 0x10            ; print from al
    xor ah, ah
    ret

;
; Print a null-terminated string.
;   - bx: address of string
;
puts:
    mov al, [bx]

    cmp al, 0
    je .exit

    call print

    inc bx
    jmp puts

    .exit:
        ret


;
; Read a string into `buffer`.
;
readstr:
    mov bx, buffer

    .readchar:
        mov ah, 0           ; read char into al
        int 0x16            ;
        xor ah, ah          ;

        cmp al, 0x0D        ; check for carriage return
        je .storestr

        push ax
        inc bx

        jmp .readchar

    .storestr:
        dec bx

        pop ax
        mov [bx], al

        cmp bx, buffer
        jle .exit

        jmp .storestr

    .exit:
        ret

;
; Print a 16 bit register in hex.
;   - reads from bx
;
printreg:
    mov cl, 3
    .loop:
        cmp cl, 0
        jl .exit

        mov dx, bx

        shl cl, 2           ; multiply then divide cl by 4
        shr dx, cl
        shr cl, 2

        and dx, 0x000f      ; keep only bottom nibble
        ; bx : aaaa bbbb cccc dddd
        call .print_nibble

        dec cl
        jmp .loop

    .print_nibble:
        cmp dx, 9           ; check nibble is numeric
        jg .letter

        jmp .numeral

    .numeral:
        add dx, 0x30        ; offset from 0x0 to '0'

        mov al, dl
        call print
        ret

    .letter:
        add dx, 0x37        ; offset from 0xa to 'a'

        mov al, dl
        call print
        ret

    .exit:
        ret

main:
    jmp $




str: db "hello world", 0

buffer: times 64 db 0



times 510-($-$$) db 0
db 0x55, 0xAA
