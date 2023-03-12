LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x10 ; PC = 0x10

start:
    clrf WREG
    clrf TRISA
    clrf TRISB
    LFSR 0,0x100 ;FSR0 point to 0x100
    LFSR 1,0x120
    MOVLW D'9'
    ADDWF TRISA,1
    clrf WREG
    
loop1:
    ADDWF POSTINC0,1
    incf WREG
    DECFSZ TRISA
    goto loop1
    
    MOVLW D'9'
    ADDWF TRISA,1
    clrf WREG
    LFSR 0,0x100
loop_add:
    ADDWF POSTINC0,0
    ADDWF POSTINC1,1
    DECFSZ TRISA
    goto loop_add
    
end
