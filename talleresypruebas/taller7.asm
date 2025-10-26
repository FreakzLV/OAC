%include "./pc_io.inc"

section .text
global _start

_start:
    ; ---- CORRIMIENTO A LA IZQUIERDA ----
    mov edx, msg1
    call puts
    call salto
    
    ; Mostrar cadena binaria inicial
    mov edx, msg1_inicial
    call puts
    mov edx, cadena_bits
    call imprimir_cadena_8bits
    
    call salto
    mov edx, msg1_corr
    call puts
    
    call capturar_corrimientos
    
    call salto
    
    ; Aplicar corrimientos
    mov edx, cadena_bits
    call corrimientos_izquierda
    
    ; Mostrar cadena despues de corrimientos
    mov edx, msg1_despues
    call puts
    mov edx, cadena_bits
    call imprimir_cadena_8bits
    
    call salto
    
    ; Convertir a valor numerico
    mov edx, cadena_bits
    call convertir_8bits_a_valor
    
    mov edx, msg1_resultado
    call puts
    
    mov esi, buffer_hex
    call printHex
    
    call salto

    ; ---- CORRIMIENTO A LA DERECHA ----
    mov edx, msg7
    call puts
    call salto
    
    ; Mostrar cadena binaria inicial
    mov edx, msg1_inicial
    call puts
    mov edx, cadena_8bits_5
    call imprimir_cadena_8bits
    
    call salto
    mov edx, msg1_corr
    call puts
    
    call capturar_corrimientos
    
    call salto
    
    ; Aplicar corrimientos
    mov edx, cadena_8bits_5
    call corrimientos_derecha
    
    ; Mostrar cadena despues de corrimientos
    mov edx, msg1_despues
    call puts
    mov edx, cadena_8bits_5
    call imprimir_cadena_8bits
    
    call salto
    
    ; Convertir a valor numerico
    mov edx, cadena_8bits_5
    call convertir_8bits_a_valor
    
    mov edx, msg1_resultado
    call puts
    
    mov esi, buffer_hex
    call printHex
    
    call salto

    ; ---- ROTACION A LA DERECHA ----
    mov edx, msg2
    call puts
    call salto
    
    ; Mostrar cadena binaria inicial
    mov edx, msg2_inicial
    call puts
    mov edx, cadena_8bits
    call imprimir_cadena_8bits
    
    call salto
    mov edx, msg2_rot
    call puts
    
    call capturar_rotaciones
    
    call salto
    
    ; Aplicar corrimientos
    mov edx, cadena_8bits
    call rotacion_derecha
    
    ; Mostrar cadena despues de corrimientos
    mov edx, msg2_despues
    call puts
    mov edx, cadena_8bits
    call imprimir_cadena_8bits
    
    call salto
    
    ; Convertir a valor numerico
    mov edx, cadena_8bits
    call convertir_8bits_a_valor
    
    mov edx, msg2_resultado
    call puts
    
    mov esi, buffer_hex
    call printHex

    call salto
    
    ; ---- ROTACION A LA IZQUIERDA ----
    mov edx, msg4
    call puts
    call salto
    
    ; Mostrar cadena binaria inicial
    mov edx, msg2_inicial
    call puts
    mov edx, cadena_8bits_2
    call imprimir_cadena_8bits
    
    call salto
    mov edx, msg2_rot
    call puts
    
    call capturar_rotaciones
    
    call salto
    
    ; Aplicar corrimientos
    mov edx, cadena_8bits_2
    call rotacion_izquierda
    
    ; Mostrar cadena despues de corrimientos
    mov edx, msg2_despues
    call puts
    mov edx, cadena_8bits_2
    call imprimir_cadena_8bits
    
    call salto
    
    ; Convertir a valor numerico
    mov edx, cadena_8bits_2
    call convertir_8bits_a_valor
    
    mov edx, msg2_resultado
    call puts
    
    mov esi, buffer_hex
    call printHex

    call salto
    
; ---- ROTACION A LA IZQUIERDA CON ACARREO ----
    mov edx, msg5
    call puts
    call salto
    
    ; Mostrar cadena binaria inicial
    mov edx, msg2_inicial
    call puts
    mov edx, cadena_8bits_3
    call imprimir_cadena_8bits
    
    call salto
    mov edx, msg2_rot
    call puts
    
    call capturar_rotaciones
    
    call salto
    
    ; Aplicar corrimientos
    mov edx, cadena_8bits_3
    call rotacion_izquierda_acarreo
    
    ; Mostrar cadena despues de corrimientos
    mov edx, msg2_despues
    call puts
    mov edx, cadena_8bits_3
    call imprimir_cadena_8bits
    
    call salto
    
    ; Convertir a valor numerico
    mov edx, cadena_8bits_3
    call convertir_8bits_a_valor
    
    mov edx, msg2_resultado
    call puts
    
    mov esi, buffer_hex
    call printHex


    call salto

; ---- ROTACION A LA DERECHA CON ACARREO ----
    mov edx, msg6
    call puts
    call salto
    
    ; Mostrar cadena binaria inicial
    mov edx, msg2_inicial
    call puts
    mov edx, cadena_8bits_4
    call imprimir_cadena_8bits
    
    call salto
    mov edx, msg2_rot
    call puts
    
    call capturar_rotaciones
    
    call salto
    
    ; Aplicar corrimientos
    mov edx, cadena_8bits_4
    call rotacion_derecha_acarreo
    
    ; Mostrar cadena despues de corrimientos
    mov edx, msg2_despues
    call puts
    mov edx, cadena_8bits_4
    call imprimir_cadena_8bits
    
    call salto
    
    ; Convertir a valor numerico
    mov edx, cadena_8bits_4
    call convertir_8bits_a_valor
    
    mov edx, msg2_resultado
    call puts
    
    mov esi, buffer_hex
    call printHex

    call salto
    
    ; Salir
    mov eax, 1
    mov ebx, 0
    int 80h

; ===== Subrutinas para captura e impresion =====

imprimir_cadena_8bits:
    push eax
    push edx
    push esi
    mov esi, 0
    
.loop:
    cmp esi, 8
    je .fin
    
    mov al, [edx + esi]
    call putchar
    
    inc esi
    jmp .loop
    
.fin:
    pop esi
    pop edx
    pop eax
    ret

; Capturar numero de rotaciones
capturar_rotaciones:
    call getche
    sub al, '0'
    mov [num_rotacion], al
    ret

; Capturar numero de corrimientos
capturar_corrimientos:
    call getche
    sub al, '0'
    mov [num_corr], al
    ret

convertir_8bits_a_valor:
    push ebx
    push ecx
    push edx
    push esi
    
    mov eax, 0  ; resultado acumulado
    mov esi, 0
    
.loop:
    cmp esi, 8
    je .fin
    
    ; Leer bit
    mov cl, [edx + esi]
    sub cl, '0'
    
    ; Si el bit es 0, no sumar nada
    cmp cl, 0
    je .siguiente
    
    ; Si el bit es 1, usar XLAT para obtener el peso
    push eax
    push esi
    mov ebx, tabla_pesos_rotacion  ; cargar direccion de la tabla
    mov eax, esi                    ; eax como indice
    xlat
    movzx eax, al                   ; extender AL a EAX
    mov ebx, eax                    ; guardar peso en EBX temporalmente
    pop esi
    pop eax
    
    ; Sumar el peso al resultado
    add eax, ebx

.siguiente:
    inc esi
    jmp .loop

.fin:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

;---- Subrutinas para corrimientos y rotaciones ----

;---- Corrimientos a la izquierda ----
corrimientos_izquierda:
    push eax
    push ecx
    push esi
    push edi
    
    mov cl, [num_corr]      ; Numero de corrimientos a realizar
    
.loop_corrimientos:
    cmp cl, 0
    je .fin
    
    ; Guardar el bit MSB (posición 0) que se va a "empujar" fuera
    mov al, [edx + 0]
    sub al, '0'              ; Convertir '0'/'1' a 0/1
    mov ah, al               ; Poner el bit en ah
    sahf                     ; Cargar ah en el registro de flags con ayuda de sahf (indicaciones del profesor)
    
    ; Ahora el carry flag contiene el MSB que se "empujo" fuera
    
    ; Mover cada bit una posicion a la izquierda
    ;  [x][x][x][x][x][x][x][x] <- 0
    ;   0  1  2  3  4  5  6  7
    ;  MSB                  LSB
    
    mov edi, 0               ; indice destino (empieza en posicion 0)
    mov esi, 1               ; indice fuente (empieza en posicion 1)
    
.loop_desplazar:
    cmp edi, 7               ; ¿Ya llegamos a la ultima posicion?
    je .insertar_cero
    
    mov al, [edx + esi]      ; Leer bit de posicion fuente
    mov [edx + edi], al      ; Escribir en posicion destino
    
    inc esi                  ; Avanzar al siguiente bit fuente
    inc edi                  ; Avanzar al siguiente bit destino
    jmp .loop_desplazar
    
.insertar_cero:
    ; Insertar '0' en la posicion LSB (posicion 7)
    mov byte [edx + 7], '0'
    
    dec cl
    jmp .loop_corrimientos
    
.fin:
    pop edi
    pop esi
    pop ecx
    pop eax
    ret




;---- Corrimientos a la derecha ----
corrimientos_derecha:
    push eax
    push ecx
    push esi
    push edi
    
    mov cl, [num_corr]      ; Numero de corrimientos a realizar
    
.loop_corrimientos:
    cmp cl, 0
    je .fin
    
    ; Guardar el bit LSB (posicion 7) que se va a "empujar" fuera
    mov al, [edx + 7]
    sub al, '0'              ; Convertir '0'/'1' a 0/1
    mov ah, al               ; Poner el bit en ah
    sahf                     ; Cargar ah en el registro de flags con ayuda de sahf (indicaciones del profesor)
    
    ; Ahora el carry flag contiene el LSB que se "empujo" fuera
    
    ; Mover cada bit una posicion a la derecha
    ; 0 ->  [x][x][x][x][x][x][x][x] 
    ;        0  1  2  3  4  5  6  7
    ;       MSB                  LSB
    
    mov edi, 7               ; indice destino (empieza en posicion 0)
    mov esi, 6               ; indice fuente (empieza en posicion 1)
    
.loop_desplazar:
    cmp edi, 0               ; ¿Ya llegamos a la ultima posicion?
    je .insertar_cero
    
    mov al, [edx + esi]      ; Leer bit de posicion fuente
    mov [edx + edi], al      ; Escribir en posicion destino
    
    dec esi                  ; Avanzar al siguiente bit fuente
    dec edi                  ; Avanzar al siguiente bit destino
    jmp .loop_desplazar
    
.insertar_cero:
    ; Insertar '0' en la posicion MSB (posicion 0)
    mov byte [edx + 0], '0'
    
    dec cl
    jmp .loop_corrimientos
    
.fin:
    pop edi
    pop esi
    pop ecx
    pop eax
    ret




; ----- Subrutina para hacer Rotacion a la Derecha ----
rotacion_derecha:
    push eax
    push ecx
    push edx
    push ebx
    push esi
    push edi
    
    mov cl, [num_rotacion]
    
.loop_rotaciones:
    cmp cl, 0
    je .fin
    
    ;[x][x][x][x][x][x][x][x]  ->  [x]
    ; 0  1  2  3  4  5  6  7        CF
    ; ^                    |
    ; |---------------------
    ; MSB                 LSB
    
    ; Guardar el bit de la posición 7 (LSB)
    mov bl, [edx + 7]
    mov ah, bl
    sahf  ; Pasar el LSB al carry
    
    ; Mover bits de derecha a izquierda
    mov edi, 7
    mov esi, 6

.mover_bits:
    cmp edi, 0
    je .colocar_bit
    
    ; Mover el bit anterior a la posicion actual
    mov al, [edx + esi]
    mov [edx + edi], al
    
    dec edi  ; Avanzar al siguiente bit
    dec esi
    jmp .mover_bits

.colocar_bit:
    ; El bit que estaba en posicion 7 va a posicion 0
    mov [edx + 0], bl
    
    ; Reiniciar índices para la proxima rotación
    mov edi, 7
    mov esi, 6
    
    dec cl
    jmp .loop_rotaciones

.fin:
    pop edi
    pop esi
    pop ebx
    pop edx
    pop ecx
    pop eax
    ret




; ----- Subrutina para hacer Rotacion a la Izquierda ----
rotacion_izquierda:
    push eax
    push ecx
    push edx
    push ebx
    push esi
    push edi
    
    mov cl, [num_rotacion]
    
.loop_rotaciones:
    cmp cl, 0
    je .fin
    
    ; [x] < -[x][x][x][x][x][x][x][x]  
    ;  CF     0  1  2  3  4  5  6  7      
    ;         |                    ^
    ;         ---------------------|
    ;         MSB                 LSB
    
    ; Guardar el bit de la posicion 0 (MSB)
    mov bl, [edx + 0]
    mov ah, bl
    sahf  ; Pasar el MSB al carry 
    
    ; Mover bits de derecha a izquierda
    mov edi, 1
    mov esi, 0

.mover_bits:
    cmp edi, 7
    je .colocar_bit
    
    ; Mover el bit anterior a la posicion actual
    mov al, [edx + edi]
    mov [edx + esi], al
    
    inc edi  ; Avanzar al siguiente bit
    inc esi
    jmp .mover_bits

.colocar_bit:
    ; El bit que estaba en posicion 7 va a posicion 0
    mov [edx + 7], bl
    
    mov edi, 1
    mov esi, 0

    dec cl
    jmp .loop_rotaciones

.fin:
    pop edi
    pop esi
    pop ebx
    pop edx
    pop ecx
    pop eax
    ret




;---- Subrutina para hacer rotacion a la izquierda con acarreo ----
rotacion_izquierda_acarreo:
    push eax
    push ecx
    push edx
    push ebx
    push esi
    push edi
    
    ; Guardar el CF actual en acarreo_temp y pasarlo a caracter para la cadena
    lahf
    and ah, 1
    add ah, '0' 
    mov [acarreo_temp], ah
    
    mov cl, [num_rotacion]
    
.loop_rotaciones:
    cmp cl, 0
    je .fin
    
    ; [x] < -[x][x][x][x][x][x][x][x]      
    ;  CF     0  1  2  3  4  5  6  7          
    ;  |                           ^
    ;  ----------------------------|
    ;        MSB                  LSB
    
    ;Guardar el MSB antes de mover bits
    mov bl, [edx + 0]   ; Guardar MSB temporalmente en BL
    
    mov edi, 1
    mov esi, 0

.mover_bits:
    cmp edi, 8       
    je .colocar_bit
    
    ; Copiar el bit siguiente a la posicion actual
    mov al, [edx + edi]  
    mov [edx + esi], al       
    
    inc esi             
    inc edi
    jmp .mover_bits

.colocar_bit:
    ; El CF anterior ponerlo en LSB
    mov al, [acarreo_temp]
    mov [edx + 7], al
    
    ; Ahora poner el MSB guardado en CF (para la proxima iteracion)
    sub bl, '0'         ; Convertir '0'/'1' a 0/1
    mov ah, bl
    sahf                ; Poner MSB en CF
    
    ; Guardar este nuevo CF
    lahf                ; CF → AH
    and ah, 1           ; Aislar CF
    add ah, '0'         ; Convertir de 0/1 a '0'/'1'
    mov [acarreo_temp], ah ; Guardar para la siguiente iteracion
    
    dec cl
    jmp .loop_rotaciones

.fin:
    pop edi
    pop esi
    pop ebx
    pop edx
    pop ecx
    pop eax
    ret




;---- Subrutina para hacer rotacion a la derecha con acarreo ----
rotacion_derecha_acarreo:
    push eax
    push ecx
    push edx
    push ebx
    push esi
    push edi
    
    lahf
    and ah, 1
    add ah, '0' 
    mov [acarreo_temp], ah
    
    mov cl, [num_rotacion]
    
.loop_rotaciones:
    cmp cl, 0
    je .fin
    
    ; [x] < -[x][x][x][x][x][x][x][x]      
    ;  CF     0  1  2  3  4  5  6  7          
    ;  |                           ^
    ;  ----------------------------|
    ;        MSB                  LSB
    
    ;Guardar el MSB antes de mover bits
    mov bl, [edx + 7]   ; Guardar MSB temporalmente en BL
    
    mov edi, 6
    mov esi, 7

.mover_bits:
    cmp edi, -1       
    je .colocar_bit
    
    ; Copiar el bit siguiente a la posicion actual
    mov al, [edx + edi]  
    mov [edx + esi], al       
    
    dec esi             
    dec edi
    jmp .mover_bits

.colocar_bit:
    ; El CF anterior ponerlo en LSB
    mov al, [acarreo_temp]
    mov [edx + 0], al
    
    ; Ahora poner el MSB guardado en CF (para la proxima iteracion)
    sub bl, '0'         ; Convertir '0'/'1' a 0/1
    mov ah, bl
    sahf                ; Poner MSB en CF
    
    ; Guardar este nuevo CF
    lahf                ; CF → AH
    and ah, 1           ; Aislar CF
    add ah, '0'         ; Convertir de 0/1 a '0'/'1'
    mov [acarreo_temp], ah ; Guardar para la siguiente iteracion
    
    dec cl
    jmp .loop_rotaciones

.fin:
    pop edi
    pop esi
    pop ebx
    pop edx
    pop ecx
    pop eax
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
    msg1 db "===== Corrimientos a la izquierda =====", 0
    msg1_inicial db "Cadena binaria inicial: ", 0
    msg1_corr db "Ingrese numero de corrimientos: ", 0
    msg1_despues db "Binario despues de corrimientos: ", 0
    msg1_resultado db "Valor en hexadecimal: ", 0


    msg2 db "===== Rotacion a la derecha =====", 0
    msg2_inicial db "Cadena binaria inicial: ", 0
    msg2_rot db "Ingrese numero para la rotacion: ", 0
    msg2_despues db "Binario despues de rotacion: ", 0
    msg2_resultado db "Valor en hexadecimal: ", 0

    msg3 db "===== Rotacion a la derecha =====", 0
    
    msg4 db "===== Rotacion a la izquierda =====", 0

    msg5 db "===== Rotacion a la izquierda con acarreo =====", 0

    msg6 db "===== Rotacion a la derecha con acarreo =====", 0

    msg7 db "===== Corrimientos a la izquierda =====", 0

    tabla_pesos db 8, 4, 2, 1
    tabla_pesos_rotacion db 128, 64, 32, 16, 8, 4, 2, 1

    cadena_bits db '01101111'  ; Cadena binaria de 4 bits predefinida en memoria (osea que no se captura se cambia desde aqui)
    cadena_8bits db '10101111' ; Cadena binaria de 4 bits predefinida en memoria (osea que no se captura se cambia desde aqui)
    cadena_8bits_2 db '10101111' ; Cadena binaria de 4 bits predefinida en memoria (osea que no se captura se cambia desde aqui)
    cadena_8bits_3 db '10101111' ; Cadena binaria de 4 bits predefinida en memoria (osea que no se captura se cambia desde aqui)
    cadena_8bits_4 db '10101111' ; Cadena binaria de 4 bits predefinida en memoria (osea que no se captura se cambia desde aqui)
    cadena_8bits_5 db '10101111' ; Cadena binaria de 4 bits predefinida en memoria (osea que no se captura se cambia desde aqui)

section .bss
    num_corr resb 1
    num_rotacion resb 1
    buffer_hex resb 10
    acarreo_temp resb 1