/*
 * File:   Lab10_advanced.c
 * Author: a0987
 *
 * Created on 2021年12月20日, 下午 11:55
 */

#include <xc.h>
#include <pic18f4520.h>


#pragma config OSC = INTIO67    // Oscillator Selecion bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // PORTB A/D Enable bit
#pragma config LVP = OFF        // Low Voltage (single supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM? Memory Code Protection bit (Data EEPROM code protection off)

#define _XTAL_FREQ 4000000



void __interrupt(low_priority) Lo_ISR(void){
    // low priority interrupt here
    return;
}

void __interrupt(high_priority) Hi_ISR(){
    // step 4
    int value = ADRESL + ((ADRESH & 0b00000011) << 8);
    int melody[10] = {1,8,4,2,1,2,1,4,1,2};
   
    //do things
    int temp = value/103;
    PORTD = melody[temp]; 
    //if (h >256)
    //clear flag bit
    PIR1bits.ADIF = 0;
    //step5 & go back step 3
    
    
     //delay at least 2tad
    __delay_us(4);
     ADCON0bits.GO = 1;
      
     
    return;
}
void main(void) {
    //configure OSC and port
    
    //OSCCONbits.IRCF = 0b100; // 1MHZ
    OSCCONbits.IRCF = 0b100; // 4MHZ
    TRISAbits.RA0 = 1; // analog input port
    TRISD = 0;
    PORTD = 0;
    
    //step1
    ADCON1bits.VCFG0 = 0;       // 上屆電壓  0:Vss
    ADCON1bits.VCFG1 = 0;       // 下屆電壓  0:Vdd
    ADCON1bits.PCFG = 0b1110;   // AN0 為analog input 其他ANx: digital I/O
    ADCON0bits.CHS = 0b0000;    // 選AN0當作analog input
    ADCON2bits.ADCS = 0b100;    // A/D conversion clock 查表後設100(4MHZ < 5.71MHz)
    ADCON2bits.ACQT = 0b010;    // Tad = 1 微秒 Acquisition time 設4tad = 4 >2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 1;        // right justfied
    
    //step 2
    PIE1bits.ADIE = 1;          // Enable A/D Converter Interrupt Enable bit
    PIR1bits.ADIF = 0;          // clear A/D Converter Interrupt Flag bit
    INTCONbits.PEIE = 1;        // Enable peripheral interrupt
    INTCONbits.GIE = 1;         // set GIE bit  (global interrupt enable bit)
    
    // step3
    ADCON0bits.GO =1; //start conversion
    
    while(1);
    return;
    
    
}
