
#include <xc.h>

extern unsigned int divide(unsigned int a, unsigned int b);
extern unsigned int divide_signed(unsigned char a, unsigned char b);
extern unsigned char mysqrt(unsigned int a); 

void main(void) {  
    volatile unsigned int res = divide_signed(255,13);
    volatile unsigned char quotient = res >> 8; //HIGH bytes of res
    volatile unsigned char remainder = res <<12 >> 12; //LOW bytes of res
    while(1)
    return;
}