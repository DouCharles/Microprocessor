LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x00
	
initial:
    clrf WREG
    clrf TRISA
    clrf TRISB
    addlw 0xC2
    movwf TRISA
    clrf WREG
    
start:
    rrncf TRISA,0 ;rotate right put the answer in WREG
    bcf WREG,7 ;set WREG bit<7> = 0
    movwf TRISB
    clrf WREG 
    addlw b'10000000'
    andwf TRISA,0
    addwf TRISB,0
    movwf TRISA
end