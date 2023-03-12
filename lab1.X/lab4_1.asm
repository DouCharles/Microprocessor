LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00

initial:
    MOVLF macro literal,F
	movlw literal
	movwf F
	endm
	
    RECT macro addr_x1,addr_y1,addr_x2,addr_y2,F
	clrf WREG
	clrf TRISA
	movf addr_x1,0  ;x1 move to WREG
	subwf addr_x2,0 ;WREG = x2 - WREG 
	movwf TRISA
	clrf WREG
	movf addr_y1,0 ; y1 move to WREG
	subwf addr_y2,0 ; WREG = y2 - WREG
	mulwf TRISA ; WREG * TRSIA
	movf PRODL,0 ; WREG = PRODL
	movwf F 
	endm
start:

    MOVLF 0x03,0x00
    MOVLF 0x09,0x01
    MOVLF 0x07,0x02
    MOVLF 0x0F,0x03
    RECT 0x00,0x01,0x02,0x03,0x04
    end
    

