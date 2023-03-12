LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x10 ; PC = 0x10
initial:
    clrf WREG
    clrf TRISA ;main loop
    clrf TRISB ;second loop remaining times
    clrf TRISC ;second loop need how many times
    clrf TRISD ;the number to insert
    clrf TRISE ;how many number to move back
    LFSR 0, 0x100 ;put the question to data memory
    MOVLW 0xB5
    ADDWF POSTINC0,1
    MOVLW 0xF3
    ADDWF POSTINC0,1
    MOVLW 0x64
    ADDWF POSTINC0,1
    MOVLW 0x7f
    ADDWF POSTINC0,1
    MOVLW 0x98
    ADDWF POSTINC0,1
    
start:
    MOVLW D'5' ; loop five times
    ADDWF TRISA,1
    LFSR 0,0x101 ; the first data to compare
    LFSR 1,0x100 ;
    LFSR 2,0x100
loop_sort:   ;insertion sort
    incf TRISC
    movff TRISC,TRISB ;move TRISC to TRISB
    clrf TRISE
    
    LFSR 1,0x100
    LFSR 2,0x100
    clrf WREG
    addwf FSR0L,0 ;let the FSR1 is in the middle
    addwf FSR1L,1
    clrf WREG
    addwf FSR0L,0 ;let the FSR2 is the first one
    decf WREG
    addwf FSR2L,1
    clrf WREG
    addwf POSTINC0,0 ; the number in WREG is ready to insert in 
    decfsz TRISA
    goto loop_compare
    goto finish
    
loop_compare:
    cpfslt POSTDEC2 ;Compare f with WREG, skip if f<w
    goto loop2
    tstfsz TRISE ;test f, skip if 0   , check if any number need to move back
    goto move_back
    goto loop_sort
loop2:
    incf TRISE
    decfsz TRISB
    goto loop_compare
    tstfsz TRISE
    goto move_back
    goto loop_sort
 
move_back:
    movwf TRISD
    clrf WREG
    LFSR 2,0x100
    addwf FSR0L,0
    decf WREG
    decf WREG
    addwf FSR2L,1
move_back_loop:
    clrf WREG
    addwf POSTDEC2,0
    clrf INDF1
    addwf POSTDEC1,1
    decfsz TRISE
    goto move_back_loop
    movf TRISD,0
    clrf INDF1
    addwf INDF1
    goto loop_sort
    
finish:
end
   
    

