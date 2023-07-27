[org 0x7c00]

jmp main


;
; Print a string
;   - bx: address of string
puts:
    mov al, [bx]
    cmp al, 0
    je exit

    mov ah, 0x0e        ; display character in tty mode
    int 0x10            ;   - read from al
    inc bx
    jmp puts

exit:
    ret

;
; Read a string into `buffer`
readstr:
    mov bx, buffer
    jmp readchar

    readchar:
        mov ah, 0           ; wait for keyboard input
        int 0x16            ;   - stored in al

        cmp al, 0x0D
        je exit

        ; mov ah, 0x0e        ; display character in tty mode
        ; int 0x10            ;   - read from al

        mov [bx], al
        inc bx

        jmp readchar


main:
    call readstr

    mov bx, buffer
    call puts

    jmp $




str: db "hello world", 0

buffer: times 10 db 0



times 510-($-$$) db 0
db 0x55, 0xAA
