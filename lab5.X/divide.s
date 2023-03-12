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
    ;step 1   need modify
    btfsc TRISD,7
    goto SET1_INITIAL
    goto SET0_INITIAL
SET1_INITIAL:
    bsf TRISB, 0
    goto ROTATE_INITIAL
SET0_INITIAL:
    bcf TRISB, 0
    bcf TRISB, 7
    rlncf TRISB, F
ROTATE_INITIAL:
    bcf TRISD, 7
    rlncf TRISD
    bsf TRISD, 0
    
LOOP:
    ;step2
    movff TRISC,WREG
    subwf TRISB,W
    
    ;test remainder 
    bn REMAINDER_SMALL
    
REMAINDER_BIG: ; remainder >= 0
    movwf TRISB
    bcf TRISB, 7
    rlncf TRISB, F
    btfsc TRISD,7
    goto SET1_BIG
    goto SET0_BIG
SET1_BIG:
    bsf TRISB, 0
    goto ROTATE_BIG
SET0_BIG:
    bcf TRISB, 0
ROTATE_BIG:
    
    bcf TRISD, 7
    rlncf TRISD
    bsf TRISD, 0
    
    decfsz TRISA
    goto LOOP
    goto FINISH
    
REMAINDER_SMALL: ;remainder < 0
    bcf TRISB, 7
    rlncf TRISB, F
    btfsc TRISD, 7
    goto SET1_SMALL
    goto SET0_SMALL
    
SET1_SMALL:
    bsf TRISB, 0
    goto ROTATE_SMALL
    
SET0_SMALL:
    bsf TRISB, 0
    
ROTATE_SMALL:
    rlncf TRISD, F
    bcf TRISD, 0
    
    
    decfsz TRISA
    goto LOOP
    goto FINISH

    
FINISH:
    bcf TRISB,0
    rrncf TRISB
    movff TRISB, 0x01
    movff TRISD, 0x02
	return

