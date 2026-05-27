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
        int _t8;
        int _t9;
        int _t10;
        int _t11;
        int _t12;
        int _t13;
        int _t14;
        int _t15;
        int _t16;

        _t2 = 0;
        _t1 = _t2;
        FORSTART_1:
        _t3 = 5;
        _t4 = _t1 < _t3;
        _t16 = !_t4;
        if(_t16) goto FOREND_1;
        _t7 = 1;
        _t8 = _t1 == _t7;
        _t9 = 3;
        _t10 = _t1 == _t9;
        _t11 = _t8 || _t10;
        _t12 = 5;
        _t13 = _t1 == _t12;
        _t14 = _t11 || _t13;
        _t15 = !_t14;
        if(_t15) goto IFEND_2;
        goto FORSTEP_1;
        IFEND_2:
        printf("%d\n", _t1);
        FORSTEP_1:
        _t5 = 1;
        _t6 = _t1 + _t5;
        _t1 = _t6;
        goto FORSTART_1;
        FOREND_1:
        return 0;
}