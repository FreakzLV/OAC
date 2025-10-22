%include "./pc_io.inc"

global _start

section .text
_start:
; -- Guardamos los numeros en las variables (espacios de memoria) -- 
    mov ebx, numero         
    mov edx, 9ABCDEF0h    
    mov [ebx], edx         

    mov edx, 12345678h    
    mov [ebx+4], edx     

    mov ebx, numero2
    mov edx, 00010001h
    mov [ebx], edx

    mov edx, 00010001h
    mov [ebx+4], edx

; -- Sumar los 2 numeros que se guardaron en memoria -- 
    mov ecx, numero 
    mov edx, numero2    
    mov ebx, resultado  

    mov eax, [ecx]      
    add eax, [edx]      
    mov [ebx], eax      ; Guardamos el resultado en la parte baja de resultado

    mov eax, [ecx+4]    
    adc eax, [edx+4]    ; Ahora si utilizamos adc porque el add anterior activo la carry flag

    mov [ebx+4], eax    ; Guardamos el resultado en la parte alta del resultado


    ; Buffer para imprimir con printHex
    mov esi, buffer
    
    ; Ejemplos del profe para mostrar espacios de memoria
    ;mov eax, num
    ;call printHex

    ;mov eax, num1
    ;call printHex

    ;mov eax, num2 
    ;call printHex

    ;mov eax, num3
    ;call printHex

; --- Impresion con datos inicializados --- 
    mov eax, [num+4]
    call printHex

    mov eax, [num]
    call printHex

    call salto

; --- Suma de los 2 numeros con adc ---
    mov eax, [resultado+4]
    call printHex

    mov eax, [resultado]
    call printHex

    call salto

    ; Sys_Exit (0)
    mov eax, 1
    mov ebx, 0
    int 80h

; ------- Subrutinas -------

; Capturar cadena terminada en '*'
capturar:
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
    mov al, 0        ; contador de coincidencias (en AL)

.loop_buscar:
    mov dl, [ebx + esi]   ; leer carácter de cadena
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

; Mostrar número en AL usando tabla y XLAT
mostrar_xlat:
    mov ebx, tabla
    xlat              
    call putchar
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

; Subrutina new_puts2
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
    msg_buscar: db 'Ingrese el caracter a buscar: ', 0
    msg_resultado: db 'Veces que se encuentra el caracter en la cadena: ',0
    tabla db '0','1','2','3','4','5','6','7','8','9'
    num: db 0F0h, 0DEh, 0BCh, 9Ah, 78h, 56h, 34h, 12h 
    num1: db 01h
    num2: db 01h, 01h
    num3: db 01h

section .bss
    cadena resb 50
    car resb 2          ; reservamos 2 bytes para el caracter
    numero resb 8
    numero2 resb 8
    resultado resb 16
    buffer resb 10