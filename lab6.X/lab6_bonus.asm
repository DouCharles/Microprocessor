LIST p=18f4520
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    CONFIG LVP = OFF
    
    L1 EQU 0x14
    L2 EQU 0x15
    L3 EQU 0x16
 
    org 0x0

DELAY macro num1,num2; DELAY d'100' , d'155' ,d'2'
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
;2+155*(2+100*(5+3)+3) = 
endm

LIGHT macro state
    
    rlncf state
    movlw b'00010001'
    addwf state, F
    movlw 0xff
    cpfseq state
    goto FINISH
    clrf state
    
    FINISH:
    movff state, LATD
 endm
	
start:
init:
    movlw 0x0f ;configure A/D
    movwf ADCON1 ;set digital i/o
   
    clrf PORTB
    bsf TRISB, 0 ;set RB0 as input
    clrf TRISD
    clrf LATD
    
    clrf WREG
    clrf 0x01
check_press:
    btfsc PORTB, 0
    bra check_press
    bra lightup

lightup:
    LIGHT 0x01
loop:
    DELAY d'100' ,d'155'
    rlncf LATD
    btfss PORTB, 0
    bra lightup
    bra loop
end












