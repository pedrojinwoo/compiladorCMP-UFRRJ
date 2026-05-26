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
        int _t17;

        _t2 = 0;
        _t1 = _t2;
        _t7 = _t1 == _t3;
        if(_t7) goto CASE1_0;
        _t8 = _t1 == _t5;
        if(_t8) goto CASE1_1;
        goto SWITCHEND_1;
        CASE1_0:
        _t4 = 0;
        printf("%d\n", _t4);
        goto SWITCHEND_1;
        CASE1_1:
        _t6 = 1;
        printf("%d\n", _t6);
        goto SWITCHEND_1;
        SWITCHEND_1:
        WHILESTART_2:
        _t9 = 5;
        _t10 = _t1 < _t9;
        _t11 = !_t10;
        if(_t11) goto WHILEEND_2;
        _t12 = 2;
        printf("%d\n", _t12);
        _t13 = 1;
        _t14 = _t1 + _t13;
        _t1 = _t14;
        _t15 = 4;
        _t16 = _t1 == _t15;
        _t17 = !_t16;
        if(_t17) goto IFEND_3;
        goto WHILEEND_2;
        IFEND_3:
        goto WHILESTART_2;
        WHILEEND_2:
        return 0;
}