#include <xc.inc>

GLOBAL _divide
    
PSECT mytext, local, class=CODE, reloc=2
 
 _divide:
    movlw 0x08
    movwf TRISA ; loop
    movff 0x01, TRISD ; dividend
    movff 0x03, TRISC ; divisor
    clrf TRISB 
    ;remainder = TRISB:TRISD
    clrf WREG
DIVISOR:
    ;step 1  shift remainder left 1 bit
    btfsc TRISD, 7 ; check if TRISD<7> == 0?  set TRISB<0> = 0 : set TRISB<0> = 1   
    bsf TRISB, 0
    
ROTATE_INITIAL:
    bcf TRISD, 7 ; rotate TRISD left 1 bit
    rlncf TRISD
    
LOOP:
    ;step2 let TRISB - TRISC     (left of remainder) - divisor
    movff TRISC, WREG
    subwf TRISB, W
    ;test if the answer < 0      if yes, jump to "remainder_small"
    bn REMAINDER_SMALL
    
REMAINDER_BIG: ; step 3a : remainder >= 0              NO restore 
    movwf TRISB
    bcf TRISB, 7 ; clear TRISB<7>
    rlncf TRISB, F ; rotate
    btfsc TRISD,7 ;check if TRISD<7> = 0? if no , TRISB<0> = 1
    bsf TRISB, 0 ;
    ;rotate
    bcf TRISD, 7
    rlncf TRISD
    bsf TRISD, 0
    
    decfsz TRISA
    goto LOOP
    goto FINISH
    
REMAINDER_SMALL: ; step 3b :remainder < 0
    bcf TRISB, 7 ;rotate
    rlncf TRISB, F
    btfsc TRISD, 7 ;check TRISD<7> = 0? if no,TRISB<0> = 1
    bsf TRISB, 0
;rotate TRISD
    rlncf TRISD, F
    bcf TRISD, 0
;repeat?
    decfsz TRISA
    goto LOOP
    goto FINISH
    
FINISH:
    ;rotate right
    bcf TRISB, 0
    rrncf TRISB
    ;move answer
    movff TRISB, 0x01
    movff TRISD, 0x02
	return

