%include "./pc_io.inc"

global _start

section .text
_start:
	mov ebx, 64h
    call printBin
    call salto

    call salto

	mov eax, 100
    mov esi, buffer
    call printHex
    call salto

    ;Sys_Exit (0)
    mov eax, 1
    mov ebx, 0
    int 80h

; '''' SUBRUTINAS ''''

; Subrutina para imprimir de hexadecimal a binario (con formato)
printBin:
    pushad
    mov eax, 0         
    mov ecx, 32         
    mov edx, 0          ; contador de grupos de 4 bits (para que se entienda mejor)

.ciclo:
    shl ebx, 1          ; desplaza el MSB al CF
    adc al, 48          ; convierte CF (0/1) en '0' o '1'
    call putchar        
    mov al, 0           

    inc edx             ; incrementa el contador de bits
    cmp edx, 4
    jne .no_espacio

    mov al, ' '         ; si van 4 bits, imprime un espacio
    call putchar
    mov al, 0
    mov edx, 0          ; reinicia el contador de grupo

.no_espacio:
    loop .ciclo
    popad
    ret

; Subrutina para salto de línea
salto:
    pushad
    mov al, 13
    call putchar
    mov al, 10
    call putchar
    popad
    ret

; Subrutina para imprimir en hexadecimal
printHex:
    pushad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28

.nxt:
    shr eax, cl
.msk:
    and eax, ebx
    cmp al, 9
    jbe .menor
    add al, 7
.menor:
    add al, '0'
    mov byte [esi], al
    inc esi
    mov eax, edx
    cmp cl, 0
    je .print
    sub cl, 4
    cmp cl, 0
    ja .nxt
    je .msk

.print:
    mov eax, 4
    mov ebx, 1
    sub esi, 8
    mov ecx, esi
    mov edx, 8
    int 80h
    popad
    ret

section .data
    msg: db 'Ingrese cadena de texto que termine en *: ', 0
    len: equ $-msg

section .bss
    num resb 4
    cad resb 50
    buffer resb 10