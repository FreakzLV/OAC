section .text

global gets
global puts
global atoi
global printDec
global printHex


;Subrutina Gets para C
gets:
    push EBP
    mov ebp, esp

    push ebx
    push edi
    push esi

    mov esi, [ebp+8] 
    mov edi, esi

.captura_loop:

    ;Equivalente a un getch, pero con interrupciones.

    mov eax, 3      
    mov ebx, 0      
    mov ecx, esi    
    mov edx, 1      
    int 80h 

    ;Compara si ya llegamos al final
    cmp byte[esi], '*'
    je .terminar_captura
    
    cmp byte[esi], ' '
    je .terminar_captura

    inc esi

    jmp .captura_loop

.terminar_captura:
    mov byte[esi], '%' ; Esto es necesario para luego imprimir con nuestro puts (anteriormente new_puts)
    mov eax, edi

    pop esi
    pop edi
    pop ebx

    mov esp, ebp
    pop EBP
    ret

;Subrutina Puts para C
puts:
    push EBP
    mov ebp, esp

    pushad 

    mov esi, [ebp+8]
    mov edi, 0

.longitud:
    cmp byte [esi+edi], '%'          ; Si es '%', terminar (este simbolo se puso en el gets anteriormente)
    je .imprimir
    
    inc edi

    jmp .longitud

.imprimir:
    mov eax, 4      
    mov ebx, 1     
    mov ecx, esi 
    mov edx, edi   ;La longitud la calculamos anteriormente, solamente se pasa a EDX
    int 80h      

    popad

    mov esp, ebp 
    pop EBP
    ret

;Subrutina Atoi para C
atoi:
    push EBP
    mov ebp, esp

    push ebx
    push edi
    push esi
    
    mov esi, [ebp+8]    
    mov edi, 0
    mov eax, 0

.ciclo:
    movzx edx, byte[esi+edi]  ; Cargar el caracter actual
    
    cmp dl, '%'
    je .fin
    
    ; Multiplicar eax por 10
    imul eax, eax, 10
    
    ; Convertir de ASCII a numero y sumarlo
    sub dl, '0'
    movzx edx, dl
    add eax, edx
    
    inc edi
    jmp .ciclo

.fin:
    pop esi
    pop edi
    pop ebx
    
    mov esp, ebp
    pop EBP
    ret

; PrintHex para C
printHex:
    push EBP
    mov ebp, esp

    pushad

    mov eax, [ebp+8]
    mov esi, hex_buffer  
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
    mov byte[esi], 0
    mov eax, 4
    mov ebx, 1
    mov ecx, hex_buffer 
    mov edx, 8
    int 80h
    
    popad
    mov esp, ebp
    pop EBP
    ret

; PrintDec para C
printDec:
    push ebp
    mov ebp, esp
    
    pushad
    
    mov eax, [ebp+8]
    mov esi, hex_buffer + 29    
    mov ebx, 10
    
.conversion:
    mov edx, 0              ; Limpiar edx para la division
    div ebx                 ; eax = eax / 10, edx = eax % 10
    add dl, '0'             
    dec esi                 ; Retroceder en el buffer
    mov [esi], dl           ; Guardar el digito
    
    ; Verificar si terminamos
    cmp eax, 0
    jne .conversion
    
    ; Calcular longitud
    mov ecx, hex_buffer + 29    
    sub ecx, esi            ; ecx = longitud
    mov edi, esi
    
    ; Imprimir
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, ecx
    int 80h
    
    popad
    mov esp, ebp
    pop ebp
    ret


section .data

section .bss
    hex_buffer resb 30
