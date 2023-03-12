LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x00
	    
intial:
    clrf WREG 
    clrf TRISA
    clrf TRISB
    clrf TRISC
    addlw 0x0D
    movwf TRISB
    clrf WREG
    addlw 0x06
    movwf TRISC
    clrf WREG
    
start:
add:
    btfsc TRISC,0;skip if(f<b>)  = 0
    addwf TRISB,0

shift:
    rlncf TRISB
    bcf TRISC,0
    rrncf TRISC
    bnz add  ;check status Z  if Z = 0 jump to add

    movwf TRISA
    
finish:
end