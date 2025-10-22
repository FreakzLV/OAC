%include "./pc_io.inc"

global _start

section .text
_start:
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

    ;Prueba de como funciona un ciclo (multiplicación)
    mov ebx, num1       
    mov dl, [ebx]     
    mov ebx, num2
    mov cl, [ebx]   
    mov ebx, num3    
    mov byte[ebx], 0 ;Para limpiarlo

;''''''Multiplicacion''''''
multi:
    add byte[ebx], dl
    loop multi

    mov al, [num3]
    mov esi, cad
    call printHex
    call salto

    mov al, [num3]   
    mov bl, [num1]   
    mov cl, 0        

;''''''Division''''''
div:
    sub al, bl      
    add byte cl, 1
    cmp al, 0     
    je fin_div       
    jmp div

fin_div:
    ; Mostrar el cociente
    mov al, cl      
    mov esi, cad
    call printHex
    call salto

    ; Salto de línea  
    call salto ;Salto de linea para separar

;''''''Contador del 1 al 100''''''
    ; se muestra el mensaje del contador
    mov edx, msg_contador
    call puts
    call salto

    ; se setea contador = 0
    mov ebx, cont
    mov byte[ebx], 0

    mov cl, 100

ciclo:
    ; suma 1 a ebx  
    add byte[ebx], 1          

    ;Cargar solo 1 byte del contador
    mov al, 0           ; Limpiar al
    mov al, [ebx]       ; Cargar solo 1 byte
    mov esi, cad
    call printHex
    call salto
    loop ciclo

    call salto

;''''''Contador del 1 al 100 imprimiendo pares''''''
    ; mostrar mensaje del contador
    mov edx,msg_contador2
    call puts
    call salto

    ; setear contador = 0
    mov ebx, cont2
    mov byte [ebx], 0

    ; Inicializar bandera en 0 (primer número será 1, que es impar)
    mov al, 0
    mov cl, 100

cont_par:
    add byte [ebx], 1        
    call par                 
    loop cont_par

    ; SYS_EXIT
    mov eax, 1
    mov ebx, 0
    int 80h

salto:
    pushad
    mov al,13
    call putchar
    mov al,10
    call putchar
    popad
    ret

par:
    cmp al, 1           
    je imprimir

    mov al, 1       ; se enciende la bandera para la siguiente iteracion
    ret

imprimir:
    ; se apaga la bandera y se imprime solo si es par
    mov al, 0
    
    ; se imprime el contenido de ebx (cont2) - solo 1 byte
    mov dl, [ebx]   ; Cargar el valor del contador en dl
    mov al, dl      ; Mover a al para printHex
    mov esi, cad
    call printHex
    call salto
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
    msg_contador: db 'Contador del 1 al 100', 0
    msg_contador2: db 'Contador del 1 al 100 con despliegue de pares', 0

section .bss; Datos no inicializados
    num1 cas 1
    num2 resb 1
    num3 resb 1
    cad resb 10
    cont resb 1
    cont2 resb 1