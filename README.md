ACTUALIZA sudo apt update

INSTALA NASM sudo apt install nasm -y

CREA CARPETAS mkdir

MUEVE EL DIRECTORIO cd /workspaces/OAC/

CREAR ARCHIVOS touch ejemplo.asm

 
ENSAMBLAJE Y EJECUCION 
nasm -f elf Practica8OAC.asm   
ld -m elf_i386 -s -o Practica8OAC Preactica8OAC.o libpc_io.a
