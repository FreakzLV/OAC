%include "./pc_io.inc"

global _start

section .text
_start:
    ;Capturar una cadena
    mov edx, msg ;Mensaje para que ingrese la cadena
    call puts
    call salto

    mov ebx, cadena
    call capturar_cadena ;Llamada a nuestra subrutina para capturar la cadena

    call salto
    call salto

    ;Verificar si una palabra está en la cadena capturada antes
    mov edx, msg_buscar
    call puts
    call salto
    
    mov ebx, palabra_buscar 
    call capturar_cadena ;Llamada a nuestra subrutina para capturar la palabra a buscar en la cadena
    call salto
    
    mov ebx, cadena  ; cadena donde buscar
    mov edi, palabra_buscar    ; palabra a buscar
    call buscar_palabra
    
    cmp eax, 1                 ; eax = 1 si encontró, 0 si no
    je .encontrada
    
    mov edx, msg_no_encontrada
    call puts
    jmp .continuar
    
.encontrada:
    mov edx, msg_encontrada
    call puts
    
.continuar:
    call salto
    call salto
    
    ;Comparar dos cadenas
    mov edx, msg_c1
    call puts
    call salto
    
    mov ebx, cadena_1
    call capturar_cadena
    call salto
    
    mov edx, msg_c2
    call puts
    call salto
    
    mov ebx, cadena_2
    call capturar_cadena
    call salto
    
    mov ebx, cadena_1
    mov edi, cadena_2
    call comparar_cadenas
    
    cmp eax, 1                 ; eax = 1 si son iguales, 0 si no
    je .iguales
    
    mov edx, msg_diferentes
    call new_puts
    jmp .fin
    
.iguales:
    mov edx, msg_iguales
    call new_puts

.fin:
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

; Subrutina para buscar una palabra en una cadena
; Entrada: ebx = cadena donde buscar, edi = palabra a buscar
; Salida: eax = 1 si encontró, 0 si no encontró
buscar_palabra:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov esi, 0           ; índice en cadena principal
    
.buscar_inicio:
    mov al, [ebx + esi]  ; carácter actual de cadena principal
    cmp al, '%'          ; fin de cadena principal
    je .no_encontrada
    
    ; Comparar desde posición actual
    mov ecx, 0           ; índice en palabra a buscar
    mov edx, esi         ; guardar posición actual en cadena principal
    
.comparar:
    mov al, [ebx + edx]  ; carácter de cadena principal
    mov ah, [edi + ecx]  ; carácter de palabra a buscar
    
    cmp ah, '%'          ; fin de palabra a buscar
    je .encontrada       ; si terminó la palabra, la encontró
    
    cmp al, '%'          ; fin de cadena principal
    je .no_encontrada
    
    cmp al, ah           ; comparar caracteres
    je .caracteres_iguales
    
    ; Si no son iguales, siguiente posición
    inc esi
    jmp .buscar_inicio
    
.caracteres_iguales:
    inc edx
    inc ecx
    jmp .comparar
    
.encontrada:
    mov eax, 1
    jmp .fin_buscar
    
.no_encontrada:
    mov eax, 0
    
.fin_buscar:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; Subrutina para comparar dos cadenas
; Entrada: ebx = cadena1, edi = cadena2
; Salida: eax = 1 si son iguales, 0 si son diferentes
comparar_cadenas:
    push ebx
    push edi
    push esi
    
    mov esi, 0           ; índice para recorrer las cadenas
    
.comparar_loop:
    mov al, [ebx + esi]  ; carácter de cadena1
    mov ah, [edi + esi]  ; carácter de cadena2
    
    cmp al, ah           ; comparar caracteres
    je .caracteres_iguales
    
    ; Si no son iguales
    mov eax, 0
    jmp .fin_comparar
    
.caracteres_iguales:
    cmp al, '%'          ; si ambos son '%', son iguales
    je .son_iguales
    
    inc esi
    jmp .comparar_loop
    
.son_iguales:
    mov eax, 1
    
.fin_comparar:
    pop esi
    pop edi
    pop ebx
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

    ;Mensaje para ingresar palabra a buscar en la cadena ingresada anteriormente
    msg_buscar: db 'Ingrese palabra a buscar en la cadena (terminar con *): ', 0

    ;Mensajes para indicar si la palabra se encuentra o no se encuentra en la cadena
    msg_encontrada: db 'La palabra SI se encuentra en la cadena%', 0
    msg_no_encontrada: db 'La palabra NO se encuentra en la cadena%', 0

    ;Mensajes de captura de cadenas para comparar que sean iguales
    msg_c1: db 'Ingrese primera cadena (terminar con *): ', 0
    msg_c2: db 'Ingrese segunda cadena (terminar con *): ', 0

    ;Mensajes para indicar si las cadenas son o no iguales
    msg_iguales: db 'Las cadenas SON IGUALES%', 0
    msg_diferentes: db 'Las cadenas SON DIFERENTES%', 0

section .bss
    ;Espacios de memoria para las cadenas
    cadena resb 50   ; Buffer para cadena
    palabra_buscar resb 50     ; Buffer para palabra a buscar
    cadena_1 resb 50       ; Buffer para primera cadena a comparar
    cadena_2 resb 50       ; Buffer para segunda cadena a comparar