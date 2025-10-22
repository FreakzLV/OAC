%include "./pc_io.inc"

global _start

section .text
_start:
    ;Capturar una cadena en minusculas y pasarla a mayusculas
    mov edx, msg ;Mensaje para que ingrese la cadena
    call puts
    call salto

    mov ebx, cadena_mayus
    call capturar_cadena ;Llamada a nuestra subrutina para capturar

    call mayus_cadena; Llamada a nuestra subrutina para pasar a mayusculas

    call salto
    mov edx, cadena_mayus
    call new_puts ;Imprimir la cadena
    call salto
    call salto

    ;Capturar una cadena e invertirla
    mov edx, msg ;Mensaje para que ingrese la cadena
    call puts
    call salto

    mov ebx, cadena_capturada
    call capturar_cadena ;Llamada a nuestra subrutina
    call salto

    mov edx, cadena_volteada
    call invertir_cadena

    mov edx, cadena_volteada
    call new_puts
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
    push esi
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
    pop esi
    pop eax
    pop ebx
    ret

; Subrutina para pasar una cadena a mayusculas
mayus_cadena:
    push eax
    push esi
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
    pop esi
    pop eax
    ret

; Subrutina para voltear una cadena
invertir_cadena:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov esi, 0
.longitud:
    mov al, [ebx + esi]
    cmp al, '%'
    je .listo
    inc esi
    jmp .longitud
    
.listo:
    ; esi = longitud de cadena
    mov ecx, esi         ; contador de caracteres a copiar
    dec esi              ; ultimo caracter valido
    mov edi, cadena_volteada  ; destino para la cadena invertida
    mov edx, 0           ; índice para el destino

.invertir_loop:
    mov al, [ebx + esi]  ; cargar carácter desde el final de cadena original
    mov [edi + edx], al
    
    inc edx
    dec esi
    loop .invertir_loop
    
    ; Terminar cadena invertida con '%' para luego imprimir con new_puts
    mov byte [edi + edx], '%'
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; Subrutina new_puts
new_puts:
    push eax
    push ebx
    push esi
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
    pop esi
    pop ebx
    pop eax
    ret

; Subrutina para salto de línea
salto:
    push eax
    mov al, 13
    call putchar
    mov al, 10
    call putchar
    pop eax
    ret

section .data
    msg: db 'Ingrese cadena de texto que termine en *: ', 0
    len: equ $-msg

section .bss
    cadena_mayus resb 50      ; Buffer para cadena para pasarla a mayusculas
    cadena_capturada resb 50   ; Buffer para cadena que se invertira
    cadena_volteada resb 50    ; Buffer para cadena la cadena volteda