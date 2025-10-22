%include "./pc_io.inc"

global _start

section .text
_start:
    ;Mostrar mensaje
    mov edx, msg
    call puts
    call salto

    ; Captura de cadena con getche
    mov ebx, cadena      ; Apuntar para almacenar la cadena
    mov esi, 0           ; esi como indicador

captura_cadena:
    call getche          ; Lee un carácter
    cmp al, 13           
    je captura_cadena    
    cmp al, 10        
    je captura_cadena   
    cmp al, '*'          ; Si el carácter es '*', terminamos el ciclo
    je salir 
    mov [ebx + esi], al  ; Almacena el carácter en la cadena
    inc esi          
    jmp captura_cadena   ; Repite el proceso

salir:
    ; Agregar '%' justo después de la cadena
    mov byte [ebx + esi], '%'
    call salto

    ; Muestra la cadena capturada con '%'
    mov edx, cadena    
    call puts           
    call salto

    ; Muestra la cadena con % al final sin el %
    mov edx, cadena    
    call new_puts     
    call salto

    ; sys_exit(0) 
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

;Mostrar cadena de texto terminada en % en base a la cadena que ya se guardo despues de capturarla y agregarle %
new_puts:
    pushad
    mov esi, 0          
    mov ebx, edx        

sig_carac:
    mov al, [ebx + esi] ; Cargar siguiente carácter desde cadena
    cmp al, '%'         
    je fin_puts     
    call putchar        ; Imprimir el carácter
    inc esi           
    jmp sig_carac       ; Repetir
        
fin_puts:
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
    msg: db 'Ingrese cadena de texto que termine en *: ',0
    len: equ $-msg

section .bss; Datos no inicializados
    cadena resb 12