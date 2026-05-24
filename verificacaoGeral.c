/*Compilador VIPERIDAE*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main() {
        int _t1;
        int _t2;
        char* _t3;

        _t2 = 1;
        _t1 = _t2;
        if(_t1) goto IFELSE_1;
        _t3 = (char*)malloc(3);
        strcpy(_t3, "Oi");
        printf("%s\n", _t3);
IFELSE_1:
        return 0;
}