%include "./pc_io.inc"

global _start

section .text
_start:
    ;Capturar una cadena en minusculas y pasarla a mayusculas
    mov edx, msg ;Mensaje para que ingrese el numero
    call puts
    call salto
    
    mov ebx, num
    inc ebx
    mov esi, cad
    mov ebx, num
    mov eax, [ebx]
    call printHex

    call salto

    ;Sys_Exit (0)
    mov eax, 1
    mov ebx, 0
    int 80h

; ------- Subrutinas -------
; Subrutina para capturar cadena terminada en '*'
capturar_cadena:
    push ebx
    push eax
    mov esi, 0           ; esi como contador

.captura_loop:
    call getche          ; Lee un carácter
    cmp al, 13           ; Enter
    je .captura_loop
    cmp al, 10           ; Nueva Linea
    je .captura_loop
    cmp al, '*'          ; Si es '*', terminar captura
    je .terminar_captura
    
    mov [ebx + esi], al  ; Almacena el carácter
    inc esi
    jmp .captura_loop

.terminar_captura:
    mov byte [ebx + esi], '%'  ; Agregar '%' al final
    pop eax
    pop ebx
    ret

; Subrutina para pasar una cadena a mayusculas
mayus_cadena:
    pushad
    mov esi, 0           ; índice en la cadena
    
.loop_mayus:
    mov al, [ebx + esi]  ; cargar carácter actual
    cmp al, '%'          ; fin de la cadena
    je .fin_mayus
    sub al, 32           ; convertir a mayúscula
    mov [ebx + esi], al  ; guardar carácter convertido
    inc esi
    jmp .loop_mayus

.fin_mayus:
    popad
    ret

; Subrutina new_puts
new_puts:
    pushad
    mov esi, 0
    mov ebx, edx

.sig_carac:
    mov al, [ebx + esi]  ; Cargar siguiente carácter
    cmp al, '%'          ; Si es '%', terminar
    je .fin_puts
    call putchar         ; Imprimir el carácter
    inc esi
    jmp .sig_carac

.fin_puts:
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