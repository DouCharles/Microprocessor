/*
 * File:   newmain.c
 * Author: a0987
 *
 * Created on 2021年10月27日, 下午 7:18
 */


#include <xc.h>

extern unsigned int divide(unsigned int a, unsigned int b);

void main(void) {
    volatile unsigned int res = divide(255,13);
    volatile unsigned char quotient = res >> 8;//HIGH bytes of res
    volatile unsigned char remainder = res << 8 >> 8;//LOW bytes of res
    while(1)
    return;
}
