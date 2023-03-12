LIST p=18f4520
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    CONFIG LVP = OFF
    
    L1 EQU 0x14
    L2 EQU 0x15
 
    org 0x0

DELAY macro num1,num2 ; DELAY d'200' , d'180'
    local LOOP1
    local LOOP2
    movlw num2
    movwf L2
    LOOP2:
	movlw num1
	movwf L1
    LOOP1:
	nop
	nop
	nop
	nop
	nop
	decfsz L1,1
	bra LOOP1
	decfsz L2,1
	bra LOOP2
endm

start:
init:
    movlw 0x0f ;configure A/D
    movwf ADCON1 ;set digital i/o
   
    clrf PORTB
    bsf TRISB ,0 ;set RB0 as input
    clrf TRISD
    movlw b'00001010'
    movwf LATD
    
check_press:
    btfsc PORTB, 0
    bra check_press
    bra lightup

lightup:
    btg LATD, 0
    btg LATD, 1
    btg LATD, 2
    btg LATD, 3
    DELAY d'200' ,d'180'
    bra check_press
end






