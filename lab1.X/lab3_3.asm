LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x00

initial:
    clrf WREG
    clrf TRISA
    clrf TRISB
    movlw 0x40
    movwf 0x000
    clrf WREG
    movlw 0x28
    movwf 0x001
    clrf WREG
start:
    movf 0x000,0 ;move 0x000 to WREG
    movwf TRISA ; move WREG to TRISA
    movf 0x001,0
    movwf TRISB
division:
    clrf WREG
    movf TRISA,0
    cpfsgt TRISB;compare f with WREG, skip if f >WREG  (TRISB >WREG  === TRISB >TRISA) 
    goto AminusB
    goto BminusA
    
AminusB:
    movf TRISB,0
    subwf TRISA,1 ;TRISA - WREG,and put the result in register 'f'(TRISA)
    bnz division ; if Z = 0 , goto division
    movf TRISB,0
    goto finish
    
BminusA:
    subwf TRISB,1
    bnz division ; if Z = 0 , goto division
    movf TRISA,0
    goto finish

finish:
    movwf 0x002
end