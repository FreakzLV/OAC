%include "./pc_io.inc"

global _start

section .text
_start:
    ; Mostrar mensaje inicial
    mov edx, msg
    call puts
    call salto
    
    ; Capturar cadena usando subrutina
    mov ebx, cadena
    call capturar_cadena
    
    ; Mostrar la cadena capturada con '%'
    call salto
    mov edx, cadena
    call puts ;Usamos el puts normal porque queremos mostrar la cadena con % al final
    call salto
    
    ; Mostrar la cadena sin el '%'
    mov edx, cadena  
    call new_puts
    call salto
    
    ; Verificar si es palíndromo usando subrutina
    mov ebx, cadena
    call verificar_palindromo
    call salto
    
    ; sys_exit(0)
    mov eax, 1
    mov ebx, 0
    int 80h

;'''''''''''''' SUBRUTINAS ''''''''''''''

; Subrutina para capturar cadena terminada en '*'
capturar_cadena:
    pushad
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
    popad
    ret

; Subrutina para verificar si una cadena es palíndromo
verificar_palindromo:
    pushad
    
    ; Encontrar la longitud de la cadena (hasta '%')
    mov esi, 0
.buscar_final:
    mov al, [ebx + esi]
    cmp al, '%'
    je .palindromo
    inc esi
    jmp .buscar_final

.palindromo:
    dec esi              ; esi apunta al último carácter válido
    mov edi, esi         ; edi = índice final
    mov esi, 0           ; esi = índice inicial

.comparar:
    cmp esi, edi
    je .esPalindromo
    mov al, [ebx + esi]  ; carácter desde el inicio
    mov ah, [ebx + edi]  ; carácter desde el final
    cmp al, ah
    je .posible
    jmp .fin_pal

.posible:
    inc esi
    dec edi
    jmp .comparar

.esPalindromo:
    mov edx, msg_palindromo
    call puts
    call salto

.fin_pal:
    popad
    ret

; Mostrar cadena terminada en '%' sin mostrar el '%'
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
    msg_palindromo: db 'es palindromo.', 0

section .bss
    cadena resb 10