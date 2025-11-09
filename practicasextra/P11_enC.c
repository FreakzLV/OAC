#include <stdio.h>

extern void gets(int *cad);
extern int puts(const char *cad);
extern unsigned int atoi(const char *cad);
extern void printHex(unsigned int num);
extern void printDec(unsigned int num);


int main(){
    //Declaraciones
    char cad[30] = {0};
    unsigned int num;

    //Capturar con gets
    printf("Ingresa una cadena que termine en * (Ej: 2345*): ");
    fflush(stdout);
    gets((int *)cad);

    //Puts
    printf("Salida en pantalla de puts: ");
    fflush(stdout);
    puts(cad);

    //Atoi
    fflush(stdout);
    num = atoi(cad);
    
    //El numero obtenido despues del atoi pasarlo a printHex
    printf("\nSalida en pantalla de printHex: ");
    fflush(stdout);
    printHex(num);
    printf("\n");

    //El numero obtenido despues del atoi pasarlo a printDec
    printf("Salida en pantalla de printDec: ");
    fflush(stdout);
    printDec(num);
    printf("\n");

    return 0;
}

