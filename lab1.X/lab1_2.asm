LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x00
	
Initial:
    
start:
    clrf WREG
    clrf TRISA ;2
    clrf TRISB ;answer
    movlw D'2'
    addwf TRISA
    movlw D'1'
    

loop:
    addwf TRISB ;TRISB = TRISB +WREG
    mulwf TRISA ; WREG * TRISA = PRODH:PRODL
    movf PRODL,0 ; move to WREG
    btfss TRISB,6;skip if bit(TRISB<6>) = 1
    goto loop
    movf TRISB,0
    
end


