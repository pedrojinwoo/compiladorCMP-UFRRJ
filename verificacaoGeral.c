/*Compilador VIPERIDAE*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main() {
        int _t1;
        int _t2;
        int _t3;
        int _t4;

        _t2 = 1;
        _t1 = _t2;
        _t3 = !_t1;
        if(_t3) goto IFEND_1;
        _t4 = 1;
        printf("%d\n", _t4);
        IFEND_1:
        return 0;
}