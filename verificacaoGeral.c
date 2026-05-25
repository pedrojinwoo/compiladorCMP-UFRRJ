/*Compilador VIPERIDAE*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main() {
        int _t1;
        int _t2;
        int _t3;
        int _t4;
        int _t5;
        int _t6;
        int _t7;

        _t2 = 0;
        _t1 = _t2;
        FORSTART_1:
        _t3 = 5;
        _t4 = _t1 < _t3;
        _t3 = 5;
        _t4 = _t1 < _t3;
        _t7 = !_t4;
        if(_t7) goto FOREND_3;
        printf("%d\n", _t1);
        FORSTEP_2:
        _t5 = 1;
        _t6 = _t1 + _t5;
        _t1 = _t6;
        goto FORSTART_1;
        FOREND_3:
        return 0;
}