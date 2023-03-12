#include <xc.inc>

GLOBAL _divide_signed
    
PSECT mytext, local, class=CODE, reloc=2
 
 _divide_signed:
    movff 0x01, 0x03 ;divisor move to 0x03 from 0x01
    movwf 0x01 ;dividend move to 0x01 from WREG
; pre_process
    clrf TRISE ;TRISE used to record if the original data > 0
    btfss 0x01, 7 ;if 0x01<7> == 1, skip (dividend)
    goto NEXT;0x01 > 0
    bsf TRISE, 1;0x01 < 0 
    decf 0x01
    comf 0x01;complement
    
NEXT:
    btfss 0x03, 7 ;if 0x03<7> == 1 skip (divisor)
    goto NEXT2;0x03 > 0
    bsf TRISE, 0;0x03 < 0
    decf 0x03
    comf 0x03
NEXT2:   
   
;divisor    
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
    
REMAINDER_BIG: ; step 3a : remainder >= 0
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
    ;post_process   check if divisor and dividend are negative, :
    ; dividend : divisor    process one by one
    ;test dividend first
    btfsc TRISE, 1 ; skip if clear
    goto DIVIDEND_NEG
    goto DIVIDEND_POS
DIVIDEND_NEG:
    btfss TRISE, 0 ;skip if clear
    goto NEG_POS;-+
    goto NEG_NEG; --
DIVIDEND_POS:
    btfss TRISE, 0 ; skip if clear
    goto FINAL;+ + 
    goto POS_NEG;+ -
NEG_POS:
    negf 0x01
    negf 0x02
    goto FINAL
NEG_NEG:
    negf 0x01
    goto FINAL
POS_NEG:
    negf 0x02
FINAL:
	return

