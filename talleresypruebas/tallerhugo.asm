%include "./pc_io.inc"

section .text
	global _start:

_start:
    mov edx, bin
    call newputs
    call salto

    call corrimiento

    mov edx, bin
    call newputs
    call salto

    mov eax, 1
    mov ebx, 0
    int 80h

    ; bin = 0 1 0 1 0 0 0 0
        ;   | | | | | | |
        ;   0 1 2 3 4 5 6 7

corrimiento:
    pushad
    mov cl, 1


    .loop_corrimiento:
        mov edi, 7
        mov esi, 6
        cmp cl, 0
        je .HOLA

        mov ah, [edx + edi]
        sub ah, '0'
        sahf

    .loop2:
        cmp edi, 0
        je .fin

        mov ah, [edx + esi]
        mov [edx + edi], ah

        dec esi
        dec edi
        jmp .loop2
    .fin:
        mov byte [edx+0], '0'
        dec cl
        jmp .loop_corrimiento
    .HOLA:
        popad
        ret

    newputs:
    pushad
    prnt:
        mov al, [edx + esi]     ; se manda a al el caracter incial
        cmp al, '%'             ; se compara al con % 
        je finputs              ; si es verdadero, se sale del ciclo

        call putchar            ; se imprime al caracter actual
        inc esi                 ; se incrementa el indice
        jmp prnt                ; se reincia el cilo de impresion
    finputs:
    popad
    ret

    salto:
        pushad
        mov al, 13
        call putchar

        mov al, 10
        call putchar
        popad
        ret

section .data
    bin: db "01010000%", 0x0A
    len: equ $-bin
section .bss
    cad resb 5