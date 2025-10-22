ACTUALIZA  sudo apt update

INSTALA NASM  sudo apt install nasm -y

CREA CARPETAS  mkdir

MUEVE EL DIRECTORIO  cd /workspaces/OAC/

CREAR ARCHIVOS  touch ejemplo.asm

ENSAMBLAJE Y EJECUCION 

nasm -f elf Practica9OAC.asm 
ld -m elf_i386 -s -o Practica9OAC Practica9OAC.o libpc_io.a
