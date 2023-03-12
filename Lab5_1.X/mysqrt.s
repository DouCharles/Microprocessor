#include <xc.inc>

GLOBAL _mysqrt
    
PSECT mytext, local, class=CODE, reloc=2
 
 _mysqrt:
    clrf WREG
    clrf TRISA
    clrf TRISB
    clrf TRISC
    
    movff 0x01, TRISA
    movff 0x02, TRISB ; original data = TRISB:TRISA
    cpfseq TRISA ; skip if f = w
    goto LOOP
    ;goto FINISH0 ; TRISA =  0
HIGH_BIT:
    cpfseq TRISB 
    goto LOOP
    goto FINISH0
LOOP:
    incf TRISC
    movff TRISC, WREG
    mulwf TRISC
    clrf WREG
    cpfsgt TRISB ; TRISB>0?
    goto COMPARE_LOW
    movff PRODH, WREG
    cpfsgt TRISB ; skip if f > w
    goto COMPARE_HIGH_EQU
    goto LOOP
COMPARE_HIGH_EQU:
    cpfseq TRISB
    goto FINISH
    goto COMPARE_LOW
COMPARE_LOW:
    movff PRODL, WREG
    cpfslt TRISA ;skip if  f < w
    goto LOOP
FINISH:
    decf TRISC
FINISH0:
    movff TRISC, WREG
    
	return
