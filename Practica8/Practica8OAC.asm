%include "./pc_io.inc"

section .text
global _start

_start:
    ; ===== Capturar e invertir cadena usando pila =====
    mov edx, msg1
    call puts
    call salto
    
    call capturar_e_invertir
    
    call salto
    call salto
    
    ; ===== Corrimientos a la derecha en cadena de 4 bits =====
    mov edx, msg3
    call puts
    call salto
    
    ; Mostrar cadena binaria inicial
    mov edx, msg3_inicial
    call puts
    call imprimir_cadena_4bits
    
    call salto
    mov edx, msg3_corr
    call puts
    
    call capturar_corrimientos
    
    call salto
    
    ; Aplicar corrimientos
    call corrimientos_derecha
    
    ; Mostrar cadena despues de corrimientos
    mov edx, msg3_despues
    call puts
    call imprimir_cadena_4bits
    
    call salto
    
    ; Convertir a valor numerico
    call convertir_4bits_a_valor
    
    mov edx, msg3_resultado
    call puts
    
    mov esi, buffer_hex
    call printHex
    
    call salto

    ; Salir
    mov eax, 1
    mov ebx, 0
    int 80h

; ===== Subrutina para capturar e invertir usando pila =====

capturar_e_invertir:
    push ebp
    mov ebp, esp        ; guardar posicion inicial
    push ebx
    push ecx
    
    mov ecx, 0          ; contador de caracteres
    
.captura_loop:
    call getche
    
    cmp al, 13
    je .captura_loop
    cmp al, 10
    je .captura_loop
    
    cmp al, '*'
    je .fin_captura
    
    push eax            ; guardar caracter en la pila
    inc ecx             ; incrementar contador
    jmp .captura_loop
    
.fin_captura:
    call salto
    mov edx, msg1_invertida
    call puts
    
    ; Imprimir en orden inverso (la pila invierte automaticamente)
.imprimir_loop:
    cmp ecx, 0
    je .fin
    
    pop eax
    call putchar
    dec ecx
    jmp .imprimir_loop
    
.fin:
    pop ecx
    pop ebx
    pop ebp
    ret

; ===== Subrutinas para mostrar y convertir una cadena binaria de 4 bits =====

; Imprimir cadena de 4 bits
imprimir_cadena_4bits:
    push eax
    push esi
    mov esi, 0
    
.loop:
    cmp esi, 4
    je .fin
    
    mov al, [cadena_4bits + esi]
    call putchar
    
    inc esi
    jmp .loop
    
.fin:
    pop esi
    pop eax
    ret

; Capturar numero de corrimientos
capturar_corrimientos:
    call getche
    sub al, '0'
    mov [num_corr], al
    ret

; Corrimiento a la derecha pasando LSB al carry flag
corrimientos_derecha:
    push eax
    push ecx
    push esi
    
    mov cl, [num_corr]
    
.loop_corrimientos:
    cmp cl, 0
    je .fin
    
    ; Obtener el LSB y pasarlo al carry flag usando SAHF
    mov al, [cadena_4bits + 3]
    sub al, '0'              ; Convertir '0'/'1' a 0/1
    mov ah, al               ; Poner el bit en AH
    sahf                     ; Cargar AH en el registro de flags con ayuda de sahf (indicaciones del profesor)
    
    ; Ahora el carry flag contiene el LSB que se "empujo" fuera
    
    ; Mover cada bit una posicion a la derecha
    ; 0 -> [x][x][x][x] 
    ;       0  1  2  3
    ;      MSB      LSB    

    mov al, [cadena_4bits + 2]
    mov [cadena_4bits + 3], al
    
    mov al, [cadena_4bits + 1]
    mov [cadena_4bits + 2], al
    
    mov al, [cadena_4bits + 0]
    mov [cadena_4bits + 1], al
    
    ; Ingresar '0' en MSB 
    mov byte [cadena_4bits + 0], '0'
    
    ; El carry flag queda con el valor del LSB expulsado
    
    dec cl
    jmp .loop_corrimientos
    
.fin:
    pop esi
    pop ecx
    pop eax
    ret

convertir_4bits_a_valor:
    push ebx
    push ecx
    push edx
    push esi
    
    mov eax, 0          ; resultado acumulado
    mov esi, 0          
    
.loop:
    cmp esi, 4
    je .fin
    
    ; Leer bit
    mov cl, [cadena_4bits + esi]
    sub cl, '0'
    
    ; Si el bit es 0, no sumar nada
    cmp cl, 0
    je .siguiente
    
    ; Si el bit es 1, usar XLAT para obtener el peso
    push eax
    push esi
    mov ebx, tabla_pesos ; cargar direccion de la tabla
    mov eax, esi         ; EAX = indice (0, 1, 2 o 3)
    xlat                 
    movzx edx, al        ; guardar peso en EDX (extendido con ceros) porque estamos pasando de AL a EDX 
                         ; por lo cual tienen tamaños diferentes y normalmente no dejaria pero con movzx si porque extendemos
    pop esi    
    pop eax
    
    ; Sumar el peso al resultado
    add eax, edx
    
.siguiente:
    inc esi
    jmp .loop
    
.fin:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; Salto de línea
salto:
    push eax
    mov al, 13
    call putchar
    mov al, 10
    call putchar
    pop eax
    ret

; Imprimir en hexadecimal
printHex:
    pushad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
    mov edi, 0

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
    mov ecx, esi
    mov edx, 8
    int 80h
    popad
    ret

section .data
    msg1 db "Ingresa la cadena para invertir (terminar con *): ", 0
    msg1_invertida db "Cadena invertida: ", 0
    
    msg3 db "===== Corrimientos a la derecha =====", 0
    msg3_inicial db "Cadena binaria inicial: ", 0
    msg3_corr db "Ingrese numero de corrimientos: ", 0
    msg3_despues db "Binario despues de corrimientos: ", 0
    msg3_resultado db "Valor en hexadecimal: ", 0
    
    tabla_pesos db 8, 4, 2, 1
    cadena_4bits db '0110'  ; Cadena binaria de 4 bits predefinida en memoria (osea que no se captura se cambia desde aqui)

section .bss
    num_corr resb 1
    buffer_hex resb 10