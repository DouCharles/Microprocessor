LIST p=18f4520
    #include<p18f4520.inc>
	    CONFIG OSC = INTIO67
	    CONFIG WDT = OFF
	    org 0x00
	
Initial:
    ;Question : use decfsz to do  15+14+13...+1  
    ;move ans in WREG
    
start:
    clrf WREG
    clrf TRISD
    clrf TRISC
    movlw D'15' ; move 15 to WREG

loop:
    addwf TRISD,F ; add WREG and TRISD and put it in TRISD
    decfsz WREG,F ; decrease WREG and check if WREG ==0 , if WREG ==0 then skip the next instruction
    goto loop
    movf TRISD,W ; move the answer from TRISD to WREG
  
end


