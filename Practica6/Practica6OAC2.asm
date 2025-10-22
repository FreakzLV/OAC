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
    
    ; Mostrar la cadena capturada
    call salto
    mov edx, msg_cadena ;Mensaje
    call puts
    call salto

    mov edx, cadena ;Mostrar la cadena con new puts
    call new_puts
    call salto
    
    ; Solicitar carácter a buscar
    mov edx, msg_char
    call puts
    
    ; Capturar carácter ignorando Enter y espacios
.capturar_char:  
    call getche
    cmp al, 13           ; Enter
    je .capturar_char
    cmp al, 10           ; Nueva Linea
    je .capturar_char
    cmp al, 32           ; Espacio
    je .capturar_char
    
    mov [char], al
    call salto
    
    ; Buscar carácter en la cadena
    mov ebx, cadena
    call buscar_caracter
    call salto
    
    ; sys_exit
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
    cmp al, 10           ; Line feed
    je .captura_loop
    cmp al, '*'          ; Si es '*', terminar captura
    je .terminar_captura
    
    mov [ebx + esi], al  ; Almacena el carácter
    inc esi
    jmp .captura_loop
    
.terminar_captura:
    mov byte [ebx + esi], 0    ; Agregar terminador nulo para finalizar la cadena
    popad
    ret

; Subrutina para buscar un carácter en la cadena SIN usar JNE
buscar_caracter:
    pushad
    mov esi, 0           ; índice para recorrer cadena
    mov edi, 0           ; contador de ocurrencias
    mov ecx, 0           ; posición actual
    
    call salto
    mov al, [char]       ; cargar carácter a buscar
    
.buscar_loop:
    mov ah, [ebx + esi]  ; cargar carácter de la cadena
    cmp ah, 0            ; si llegamos al final (terminador nulo)
    je .mostrar_resultados
    
    cmp ah, al           ; comparar con carácter buscado
    je .caracter_encontrado  ; Si ES igual, saltar a procesamiento
    
    ; Si llegamos aquí, NO es igual, continuar con siguiente carácter
    jmp .siguiente_char
    
.caracter_encontrado:
    ; Si encontramos el carácter
    inc edi              ; incrementar contador
    
    ; Mostrar posición encontrada
    push eax             ; preservar carácter buscado
    mov edx, msg_encontrado
    call puts
    
    ; Mostrar número de posición
    push edi
    mov eax, ecx         ; posición actual en eax
    call imprimir_numero
    pop edi
    call salto
    pop eax              ; restaurar carácter buscado
    
.siguiente_char:
    inc esi              ; siguiente carácter en cadena
    inc ecx              ; siguiente posición
    jmp .buscar_loop
    
.mostrar_resultados:
    call salto
    mov edx, msg_total
    call puts
    
    ; Mostrar total de ocurrencias
    mov eax, edi         ; número total en eax
    call imprimir_numero
    
    call salto
    
    popad
    ret

; Subrutina para imprimir un número decimal SIN JNE
imprimir_numero:
    pushad
    
    ; Si el número es 0, imprimir directamente
    cmp eax, 0
    je .imprimir_cero    ; Si ES cero, saltar
    jmp .convertir       ; Si NO es cero, convertir
    
.imprimir_cero:
    mov al, '0'
    call putchar
    jmp .fin_imprimir
    
.convertir:
    mov ebx, 10          ; divisor
    mov ecx, 0           ; contador de dígitos
    mov esi, buffer_num  ; buffer para almacenar dígitos
    
    ; Convertir número a string (al revés)
.dividir:
    mov edx, 0           ; limpiar edx para división
    div ebx              ; eax / 10, resultado en eax, resto en edx
    add dl, '0'          ; convertir resto a ASCII
    mov [esi + ecx], dl  ; almacenar dígito
    inc ecx              ; incrementar contador
    cmp eax, 0           ; si queda algo por dividir
    je .imprimir_digitos ; Si YA terminamos, imprimir
    jmp .dividir         ; Si AÚN hay más, seguir dividiendo
    
    ; Imprimir dígitos en orden correcto (desde el final del buffer)
.imprimir_digitos:
    dec ecx
    mov al, [esi + ecx]
    call putchar
    cmp ecx, 0
    je .fin_imprimir     ; Si YA terminamos, salir
    jmp .imprimir_digitos ; Si AÚN hay más, seguir imprimiendo
    
.fin_imprimir:
    popad
    ret

; Mostrar cadena terminada en nulo
new_puts:
    pushad
    mov esi, 0
    
.sig_carac:
    mov al, [edx + esi]  ; Cargar siguiente carácter
    cmp al, 0            ; Si es terminador nulo, terminar
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

section .data
    msg: db 'Ingrese cadena de texto que termine en *: ', 0
    len: equ $-msg
    msg_cadena: db 'Cadena capturada: ', 0
    msg_char: db 'Ingrese el caracter a buscar: ', 0
    msg_encontrado: db 'Encontrado en posicion: ', 0
    msg_total: db 'Total de ocurrencias: ', 0

section .bss
    cadena resb 50      ; Buffer para cadena
    char resb 1   ; Carácter a buscar
    buffer_num resb 10   ; Buffer para conversión numérica