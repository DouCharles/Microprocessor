LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00

Initial:
    clrf WREG
    clrf TRISA
    clrf TRISB
    clrf TRISC

Start:
    movlw 0x00
    movwf TRISA ; F0
    movlw 0x01
    movwf TRISB ; F1
    movlw 0x05
    movwf TRISC ; loop times
    clrf WREG
    rcall Fib
    rcall Finish
   
Fib: ;subroutine
    movf TRISA,0 ;0x1A
    movff TRISB,TRISA
    addwf TRISB
    movlw 0x1A  ; set PCL
    decfsz TRISC
    movwf PCL
    movf TRISB,0
    movwf 0x000
    return

Finish:
    end