LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x00
	    
initial:
Q1:
    ;Q1 initial
    movlw 0xCF
    movff WREG,0x001
    movlw 0xFB
    movff WREG, 0x002
    movlw 0x08
    movff WREG, 0x000
    movff 0x001, 0x011
    movff 0x002, 0x012

Check:
    
    btfss 0x011,0
    goto Test0
    btfss 0x012,7
    goto Diffirent
    rrncf 0x011,F
    rlncf 0x012,F
    decfsz 0x000
    goto Check
    goto Same
Test0:
    btfsc 0x012,7
    goto Diffirent
    rrncf 0x011,F
    rlncf 0x012,F
    decfsz 0x000
    goto Check
    goto Same
Diffirent:
    movlw 0x01
    movwf 0x003
    goto Finish
Same:
    movlw 0xFF
    movwf 0x003
;    btfss 0x101
Finish:
end
    


    
    

