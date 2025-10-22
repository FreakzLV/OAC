%include "./pc_io.inc"

global _start

section .text
_start:
    ; ===== Buscar carácter =====
    ; Mostrar mensaje para ingresar cadena
    mov edx, msg
    call puts
    call salto

    mov ebx, cadena
    call capturar_cadena             ; Capturar cadena terminada en '*'

    call salto
    call salto

    ; Mostrar mensaje para ingresar caracter a buscar
    mov edx, msg_buscar
    call puts
    call salto

    call getche
    mov cl, al             ; guardar carácter a buscar en CL
    call buscar_caracter   ; cuenta apariciones y deja resultado en AL

    call salto
    mov edx, msg_resultado
    call puts

    call mostrar_xlat      ; muestra con tabla + xlat
    call salto
    call salto

    ; ===== Contar palabras =====
    mov edx, msg_entrada_palabras
    call puts
    call salto
    
    mov ebx, cadena2
    call capturar_cadena             ; Capturar segunda cadena para contar palabras
    
    call salto
    call salto
    
    mov edx, msg_palabras
    call puts
    
    mov ebx, cadena2
    call contar_palabras    ; cuenta palabras, resultado en AL
    
    mov esi, buffer_hex     ; apuntar ESI al buffer
    call printHex           ; muestra número en hexadecimal
    call salto
    call salto

    ; ===== Comparar cadenas =====
    mov edx, msg_comparar
    call puts
    call salto

    mov ebx, cadena3
    call capturar_cadena           ; Capturar tercera cadena

    call salto
    call salto

    mov ebx, cadena2        ; Cadena de palabras (segunda)
    mov edi, cadena3        ; Cadena para comparar (tercera)
    call comparar_cadenas   ; compara, resultado en AL (0=diferentes, 1=iguales)

    mov edx, msg_comp
    call puts

    cmp al, 1
    je .son_iguales
    
    mov edx, msg_diferentes
    call puts
    jmp .fin_comparacion

.son_iguales:
    mov edx, msg_iguales
    call puts

.fin_comparacion:
    call salto

    ; Sys_Exit (0)
    mov eax, 1
    mov ebx, 0
    int 80h

; ------- Subrutinas -------

; Capturar cadena terminada en '*'
capturar_cadena:
    push ebx
    push eax
    push esi
    mov esi, 0           ; Contador de caracteres

.captura_loop:
    call getche          ; Leer un caracter
    cmp al, 13           ; Enter
    je .captura_loop
    cmp al, 10           ; Nueva linea
    je .captura_loop
    cmp al, '*'          ; Si es '*', terminar captura
    je .terminar_captura
    
    mov [ebx + esi], al  ; Almacenar caracter
    inc esi
    jmp .captura_loop

.terminar_captura:
    mov byte [ebx + esi], '%'  ; Poner terminador '%'
    pop esi
    pop eax
    pop ebx
    ret

; Subrutina para contar cuántas veces aparece CL (caracter) en cadena [EBX]
; Resultado se deja en AL, luego se puede usar con xlat
buscar_caracter:
    push ebx
    push ecx
    push edx
    push esi

    mov esi, 0       ; índice de la cadena
    mov al, 0        ; contador de coincidencias

.loop_buscar:
    mov dl, [ebx + esi]   ; leer caracter de cadena
    cmp dl, '%'           ; Si es el fin de la cadena terminamos
    je .fin_buscar

    cmp dl, cl            ; el caracter coincide con el caracter actual de la cadena?
    je .incrementar       ; si son iguales se incrementa el contador

    jmp .siguiente        ; si son diferentes pasamos al siguiente caracter de la cadena

.incrementar:
    inc al ; Incrementamos nuestro contador de coincidencias

.siguiente:
    inc esi ; Incrementamos nuestro indice para movernos por la cadena
    jmp .loop_buscar ; Volvemos al loop

.fin_buscar:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; ===== Contar palabras =====
; Entrada: EBX apunta a la cadena terminada en '%'
; Salida: AL contiene el número de palabras
; Una palabra es una secuencia de caracteres no-espacios
contar_palabras:
    push ebx
    push ecx
    push edx
    push esi

    mov esi, 0          ; índice en la cadena
    mov al, 0           ; contador de palabras
    mov cl, 0           ; 0=fuera de palabra, 1=dentro de palabra

.loop_palabras:
    mov dl, [ebx + esi] ; leer caracter actual
    cmp dl, '%'         ; para verificar si se acabo
    je .fin_contar_palabras

    ; Verificar si es espacio 
    cmp dl, ' '
    je .es_espacio

    ; Es un carácter valido
    cmp cl, 0           ; estabamos fuera de una palabra?
    je .nueva_palabra   ; si estabamos fuera entonces es nueva palabra
    jmp .siguiente_palabra  ; si no, continuar
    
.nueva_palabra:
    ; Comenzamos una nueva palabra
    inc al              ; incrementar contador de palabras
    mov cl, 1           ; marcar que estamos dentro de palabra
    jmp .siguiente_palabra

.es_espacio:
    mov cl, 0           ; marcar que estamos fuera de palabra

.siguiente_palabra:
    inc esi
    jmp .loop_palabras

.fin_contar_palabras:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; ===== Comparar dos cadenas =====
; Entrada: EBX apunta a la primera cadena, EDI apunta a la segunda cadena
; Salida: AL = 1 si son iguales, AL = 0 si son diferentes
; Ambas cadenas deben terminar en '%'
comparar_cadenas:
    push ebx
    push edi
    push ecx
    push edx
    push esi

    mov esi, 0          ; indice para recorrer las cadenas

.loop_comparar:
    mov cl, [ebx + esi] ; caracter de la primera cadena
    mov dl, [edi + esi] ; caracter de la segunda cadena

    ; Verificar si ambos llegaron al final
    cmp cl, '%'
    je .verificar_fin_ambas

    ; Si los caracteres son diferentes, las cadenas son diferentes
    cmp cl, dl
    je .caracteres_iguales
    jmp .cadenas_diferentes

.caracteres_iguales:
    ; caracteres iguales, continuar
    inc esi
    jmp .loop_comparar

.verificar_fin_ambas:
    ; si la primera cadena termino, verificar si la segunda tambien
    cmp dl, '%'
    je .cadenas_iguales
    jmp .cadenas_diferentes

.cadenas_iguales:
    mov al, 1           ; retornar 1 (iguales)
    jmp .fin_comparar

.cadenas_diferentes:
    mov al, 0           ; retornar 0 (diferentes)

.fin_comparar:
    pop esi
    pop edx
    pop ecx
    pop edi
    pop ebx
    ret

; Mostrar número en AL usando tabla y XLAT
mostrar_xlat:
    push ebx
    mov ebx, tabla
    xlat
    call putchar
    pop ebx
    ret

; Salto de linea
salto:
    push eax
    mov al, 13
    call putchar
    mov al, 10
    call putchar
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

; Subrutina new_puts2 (subrutina que agrego el profe en el pizarron)
new_puts2:
    push edi
    push eax
    push edx
    push esi

    mov edi, 0
.ciclo:
    add edx, edi
    mov al, [edx+esi*4]
    cmp al, "%"
    je .fin_ciclo
    inc edi
    call putchar
    jmp .ciclo
    
.fin_ciclo:
    pop esi
    pop edx
    pop eax
    pop edi
    ret

; Mostrar número en hexadecimal
; Entrada: EAX = valor a convertir, ESI = dirección del buffer
printHex:
    pushad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
    mov edi, 0          ; contador de posición en buffer
.nxt: 
    shr eax, cl
.msk: 
    and eax, ebx
    cmp al, 9
    jbe .menor
    add al, 7
.menor:
    add al, '0'
    mov byte [esi + edi], al
    inc edi
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
    mov ecx, esi        ; dirección del buffer
    mov edx, 8          ; 8 caracteres
    int 80h
    popad
    ret

section .data
    msg: db 'Ingrese cadena de texto que termine en *: ', 0
    msg_buscar: db 'Ingrese el caracter a buscar: ', 0
    msg_resultado: db 'Veces que se encuentra el caracter en la cadena: ',0

    msg_entrada_palabras: db 'Ingrese cadena para contar palabras (termine en *): ', 0
    msg_palabras: db 'Numero de palabras en la cadena: ',0

    msg_comparar: db 'Ingrese otra cadena para comparar (termine en *): ', 0
    msg_comp: db 'Resultado de la comparacion: ', 0
    msg_iguales: db 'Las cadenas son IGUALES', 0
    msg_diferentes: db 'Las cadenas son DIFERENTES', 0
    tabla db '0','1','2','3','4','5','6','7','8','9'

section .bss
    cadena resb 50
    cadena2 resb 50
    cadena3 resb 50
    car resb 1          ; reservamos 1 byte para el caracter
    buffer_hex resb 8   ; buffer para printHex