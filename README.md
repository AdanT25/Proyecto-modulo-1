# Proyecto-modulo-1
# Visor de Memoria en Ensamblador x86-64 (Proyecto Módulo 1)

Este proyecto desarrolla un visor de memoria de baja nivel escrito en ensamblador x86-64 para arquitectura Windows. El programa recorre un arreglo de 10 elementos de 64 bits (`DQ`), calcula sus direcciones de memoria consecutivas y muestra tanto la dirección como el valor almacenado formateados en representación hexadecimal de 16 dígitos en mayúsculas.

## Especificaciones Técnicas

* **Lenguaje:** Ensamblador x86-64 (Sintaxis MASM/UASM).
* **Ensamblador:** UASM v2.57 (`uasm64`).
* **Enlazador:** GoLink (`GoLink.exe`).
* **Arquitectura:** Windows x64 ABI.
* **Librerías del Sistema:** `kernel32.dll` (`GetStdHandle`, `WriteConsoleA`, `ExitProcess`).

## Estructura del Código

1. **Sección `.data`:**
   * `arreglo`: Arreglo de 10 elementos de 64 bits (`DQ`).
   * `hex_chars`: Tabla de conversión a caracteres hexadecimales en mayúsculas (`'0123456789ABCDEF'`).
   * Buffers y etiquetas de formato de texto (`Direccion: `, ` Valor: `).

2. **Procedimientos Principales:**
   * `print_hex_qword`: Convierte un valor de 64 bits a 16 dígitos hexadecimales procesando bloques de 4 bits mediante desplazamientos a la derecha (`shr rax, 4`) y enmascaramiento (`and rdx, 0Fh`).
   * `print_string`: Calcula dinámicamente la longitud de la cadena con `repne scasb` e invoca la API `WriteConsoleA`.
   * `main`: Inicializa los punteros, realiza el recorrido indirecto a través del registro `RBX` incrementando de 8 en 8 bytes y gestiona el ciclo de iteración.

---

## Instrucciones de Compilación y Enlazado

Abre una terminal (`cmd` o `MSYS2 / UCRT64`) en la carpeta del proyecto y ejecuta los siguientes comandos:

```cmd
uasm64 -win64 proyecto_modulo1.asm
GoLink.exe proyecto_modulo1.obj kernel32.dll /fo proyecto_modulo1.exe /console /entry main
```
## Capturas del funcionamiento del proyecto
<img width="1709" height="820" alt="image" src="https://github.com/user-attachments/assets/5274b872-3937-4345-b264-75f363481a64" />
<img width="1915" height="1129" alt="image" src="https://github.com/user-attachments/assets/865e4acc-e356-4a5f-bd0a-7aa75b4e7691" />




