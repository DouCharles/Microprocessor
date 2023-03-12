LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x00
start:
    clrf WREG
    clrf TRISD 
    clrf TRISC 
    clrf TRISB 
    clrf TRISA 
Q1:
    movlw 0xD9 ; put data in WREG
    movwf 0x001; place data in memory
    movwf TRISA
    movlw 0x9B
    movwf 0x002
    movwf TRISB
    
    movlw D'9'
    movwf TRISC
    
loop:
    dcfsnz TRISC ;decrement f, skip if not 0
    goto ans1
    rlncf TRISB
    rrncf TRISA
    btfsc TRISA,0; skip if (f<b>) = 0
    goto test2
    goto test1
test1:
    btfsc TRISB,7 ;skip if (f<b>) = 0
    goto loop
    goto ans2
test2:
    btfss TRISB,7; skip if(f<b>) = 1
    goto loop
    goto ans2
    
   

ans1: ;yes
    movlw 0xFF
    movwf 0x003
    tstfsz TRISD
    goto finish
    goto Q2
ans2: ;wrong
    movlw 0x01
    movwf 0x003
    tstfsz TRISD
    goto finish
    goto Q2
    
Q2:
    movlw D'1'
    movwf TRISD
    movlw 0xCF ; put data in WREG
    movwf 0x001; place data in memory
    movwf TRISA
    movlw 0xFB
    movwf 0x002
    movwf TRISB
    movlw D'4'
    movwf TRISC
    goto loop
    
finish:

end


