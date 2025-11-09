%include "./pc_io.inc"

section .text
global _start

_start:
    ; Ejercicio 6 del examen
    mov eax, 65h
    mov byte [num_rotacion], 0

    call valor_a_binario
    
    mov edx, cadena_binaria
    call rotacion_izquierda_acarreo
    
    mov edx, cadena_binaria
    call imprimir32

    call salto
    call salto


    ; Ejercicio 7 del examen
    mov ebx, 64h
    call printBin
    
    call salto
    call salto


    ; Ejercicio 8 del examen
    mov esi, cadena     
    mov edi, palabra    

    call contar_palabra 
    call printHex
    
    call salto
    call salto

    ; Salir
    mov eax, 1
    mov ebx, 0
    int 80h


; Ejercicio numero 6 del examen
valor_a_binario:
    pushad
    
    mov edi, cadena_binaria
    mov ecx, 32             ; 32 bits
    
.convertir_bit:
    mov edx, 0
    mov ebx, 2
    div ebx                 ; Dividir en base 2
    
    add dl, 48              ; Pasar de numero a cadena
    mov [edi + ecx - 1], dl ; Guardar de derecha a izquierda
    
    dec cl
    jne .convertir_bit
    
    popad
    ret

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
    cmp edi, 32       
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
    mov [edx + 31], al
    
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

imprimir32:
    push eax
    push edx
    push esi
    mov esi, 0
    
.loop:
    cmp esi, 32
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

; Ejercicio numero 7 del examen
printBin:
    pushad
    mov al, 0
    mov ecx, 32
.ciclo:
    cmp cl, 0
    je fin

    shl ebx, 1
    adc al, 48
    call putchar
    mov al, 0
    dec cl
    jmp .ciclo

fin:
    popad
    ret


; Ejercicio numero 8 del examen
contar_palabra:
    push ebx
    push ecx
    push edx
    push edi
    push esi
    
    mov al, 0       ; contador de veces
    
.buscar:
    mov ebx, edi        ; puntero palabra
    mov ecx, esi        ; puntero cadena
    
.comparar:
    mov dl, [ecx]       ; char cadena
    mov dh, [ebx]       ; char palabra
    
    cmp dh, 0           
    je .encontrada
    
    cmp dl, '%'       
    je .fin_contar
    
    cmp dl, dh          ; caracter diferente
    jne .sig
    
    inc ecx
    inc ebx
    jmp .comparar
    
.encontrada:
    inc al              ; le sumamos uno al contador
    
.sig:
    inc esi             ; mover inicio de la cadena
    cmp byte [esi], '%' ; para el fin de la cadena
    jne .buscar
    
.fin_contar:
    pop esi
    pop edi
    pop edx
    pop ecx
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
    cadena  db "Bola ggola holaa hola mundo mmudno hola%" ;Cadena para buscar palabra
    palabra db "hola", 0 ;Palabra a buscar en la cadena

section .bss
    buffer resb 10
    cadena_binaria resb 32
    acarreo_temp resb 1
    num_rotacion resb 1

