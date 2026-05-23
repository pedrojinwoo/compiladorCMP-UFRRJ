/*Compilador VIPERIDAE*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char _stringBuffer[2048];
int _stringLength(char* _str);

int main() {
        char* _t1;
        char* _t2;
        int _t3;
        int _t4;

        scanf(" %2047[^\n/]", _stringBuffer);
        _t3 = _stringLength(_stringBuffer);
        _t1 = (char*)malloc(_t3);
        strcpy(_t1, _stringBuffer);
        scanf(" %2047[^\n/]", _stringBuffer);
        _t4 = _stringLength(_stringBuffer);
        _t2 = (char*)malloc(_t4);
        strcpy(_t2, _stringBuffer);
        printf("%s\n", _t1);
        printf("%s\n", _t2);
        return 0;
}

int _stringLength(char* _str) {
        int _len;
        int _len2;
        _len = 0;
        _len2 = 0;
        while(_str[_len] != '\0') {
                _len++;
        }
        _len2 = _len + 1;
        _len = _len2;
        return _len;
}