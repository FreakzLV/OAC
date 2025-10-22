%include "./pc_io.inc"

global _start

section .text
_start:
    ;mov eax, 4      
    ;mov ebx, 1     
    ;mov ecx, msg  
    ;mov edx, len    
    ;int 80h    

    ;Pedir primer numero
    mov edx, msg
    call puts
    call salto

    ;mov eax, 3      
    ;mov ebx, 0      
    ;mov ecx, num1    
    ;mov edx, 1      
    ;int 80h   

    ;Mostrarlo y guardarlo
    call getche
    mov ebx, num1
    mov [ebx],al
    call salto

    ;mov eax, 4      
    ;mov ebx, 1     
    ;mov ecx, num1
    ;mov edx, 1    
    ;int 80h    

    ;Pedir segundo numero
    mov edx,msg
    call puts
    call salto

    ;Mostrarlo y guardarlo
    call getche
    mov ebx, num2
    mov [ebx],al
    call salto

    ; Sumar los números
    mov ebx, num1
    mov al, [ebx]
    mov ebx, num2
    add al,[ebx]
    call putchar
    call salto

    call salto ;Separar secciones

    ;Pedir primer numero - Decimales
    mov edx, msg
    call puts
    call salto

    ;Mostrarlo y guardarlo
    call getche
    mov ebx, num1
    sub al, '0' ;Le restamos el 0 que en ASCII es '48' para que su suma de el valor numerico
    mov[ebx], al
    call salto

    ;Pedir segundo numero - Decimales
    mov edx,msg
    call puts
    call salto

    ;Mostrarlo y guardarlo
    call getche
    sub al, '0' ;Le restamos el 0 que en ASCII es '48' para que su suma de el valor numerico
    mov ebx, num2
    mov[ebx], al
    call salto

    ; Sumar los números - Decimal
    mov ebx, num1
    mov al, [ebx]
    mov ebx, num2
    add al,[ebx]
    add al, '0' ;Para que si me de el 7 en lugar de BEL
    call putchar
    call salto

    call salto ;Para separar secciones

    ;Prueba de como funciona un ciclo (multiplicación)
    mov ebx, num1        
    mov dl, [ebx]    
    mov ebx, num2
    mov cl, [ebx]  
    mov ebx, num3   
    mov byte[ebx], 0   

multi:
    add byte[ebx], dl
    loop multi
    
    ; Cargar el resultado en eax y preparar esi para printHex
    mov eax, 0
    mov al, [num3] 
    call printHex
    call salto;

    
    ; sys_exit(return_code)
    mov eax, 1        ; sys_exit syscall
    mov ebx, 0        ; return 0 (todo correcto)
    int 80h

salto: 
    pushad
    mov al,13
    call putchar
    mov al,10
    call putchar
    popad
    ret

;en eax el valor a convertir mostrar en hexadecimal
printHex:
    pushad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
    
.nxt: 
    shr eax,cl

.msk: 
    and eax,ebx
    cmp al, 9
    jbe .menor
    add al,7

.menor:
    add al,'0'
    mov byte [esi],al
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
    
section .data ;Datos inicializados
    msg: db 'Ingrese un digito (0-9)',0
    len: equ $-msg      

section .bss; Datos no inicializados 
    num1 resb 1
    num2 resb 1
    num3 resb 1