%include "./pc_io.inc"

global _start

section .text
_start:
    ;mov eax, 4      
    ;mov ebx, 1     
    ;mov ecx, msg  
    ;mov edx, len    
    ;int 80h      

    mov edx,msg
    call puts
    call salto

    ;mov eax, 3      
    ;mov ebx, 0      
    ;mov ecx, num1    
    ;mov edx, 1      
    ;int 80h 

    call getche
    mov ebx, num
    mov [ebx],al
    call salto

    ;mov eax, 4      
    ;mov ebx, 1     
    ;mov ecx, msg2 
    ;mov edx, len    
    ;int 80h      

    ; Pedir segundo número
    mov edx,msg
    call puts
    call salto
    
    ;mov eax, 3      
    ;mov ebx, 0      
    ;mov ecx, num2    
    ;mov edx, 1      
    ;int 80h 

    call getche
    mov ebx, num2
    mov [ebx],al
    call salto
    

    ; sys_write(stdout,num,1)

    ;mov eax, 4     
    ;mov ebx, 1      
    ;mov ecx, num
    ;mov edx, 1   
    ;int 80h
  
    ; Sumar los números
    mov ebx, num
    mov al, [num2]
    add byte[ebx], al
    mov al,[ebx]
    
    call putchar
    call salto
    
    ; sys_exit(0) 
    mov eax, 1      
    mov ebx, 0      
    int 80h

salto:
    pushad
    mov al,13
    call putchar
    mov al, 10
    call putchar
    popad
    ret

section .data; Datos inicializados
    msg: db "Ingrese un digito (0-9)", 0;
    len: equ $-msg
section .bss; Datos no inicializados
    num resb 1
    num2 resb 1
