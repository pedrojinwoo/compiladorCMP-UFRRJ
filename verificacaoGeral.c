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
        int _t18;

        _t2 = 0;
        _t1 = _t2;
        _t3 = 0;
        _t8 = _t1 == _t3;
        if(_t8) goto CASE1_0;
        _t5 = 1;
        _t9 = _t1 == _t5;
        if(_t9) goto CASE1_1;
        _t10 = _t1 == 0;
        if(_t10) goto DEFAULT_1;
        goto SWITCHEND_1;
        CASE1_0:
        _t4 = 0;
        printf("%d\n", _t4);
        goto SWITCHEND_1;
        CASE1_1:
        _t6 = 1;
        printf("%d\n", _t6);
        goto SWITCHEND_1;
        DEFAULT_1:
        _t7 = 2;
        printf("%d\n", _t7);
        goto SWITCHEND_1;
        SWITCHEND_1:
        _t11 = 0;
        _t16 = _t1 == _t11;
        if(_t16) goto CASE2_2;
        _t13 = 1;
        _t17 = _t1 == _t13;
        if(_t17) goto CASE2_3;
        _t18 = _t1 == 0;
        if(_t18) goto DEFAULT_2;
        goto SWITCHEND_2;
        CASE2_2:
        _t12 = 0;
        printf("%d\n", _t12);
        goto SWITCHEND_2;
        CASE2_3:
        _t14 = 1;
        printf("%d\n", _t14);
        goto SWITCHEND_2;
        DEFAULT_2:
        _t15 = 2;
        printf("%d\n", _t15);
        goto SWITCHEND_2;
        SWITCHEND_2:
        return 0;
}