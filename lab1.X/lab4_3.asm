LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
    
Initial:
    clrf WREG
    clrf TRISA ;accumulator
    clrf TRISC
    movlw 0x06 ;Fn , n = 6
    movwf TRISC 
    lfsr 0,0x010 ; stack
    
    rcall Fib_recur
    movwf 0x000
    rcall Finish
    
Fib_recur:
    ;push
    movff TRISA,POSTINC0
    movff TRISC,POSTINC0
    movlw 0x01
    cpfsgt TRISC  ;if TRISC > 0x01 , goto Recursive
    goto F10 ; if TRISC < 2
    goto Recursive ; else
F10:
    decf FSR0L ;recovery
    decf FSR0L
    tstfsz TRISC
    goto F1
    goto F0
F1:
    movlw 0x01
    return
F0:
    movlw 0x00
    return
Recursive:
    clrf WREG
    decfsz TRISC
    rcall Fib_recur ;F(n-1) 
    ;pop
    decf FSR0L
    movff POSTDEC0,TRISC
    movff INDF0,TRISA
    ;push back
    movff TRISA,POSTINC0
    movff TRISC,POSTINC0
    ; accumulate
    addwf TRISA
    movff TRISA,POSTINC0
    
    clrf TRISA
    decf TRISC
    decf TRISC
    rcall Fib_recur ;F(n-2)
    decf FSR0L ;because the pointer is at a null space which is to place data
    movff INDF0,TRISA
    ;pop
    addwf TRISA,0 ;Fn ans
    decf FSR0L
    movff POSTDEC0,TRISC
    movff INDF0,TRISA
    return
    
Finish:
    end
