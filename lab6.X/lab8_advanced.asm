LIST p = 18f4520
#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)


org 0x00
 STATE equ 0x00
bra INITIAL
  
org 0x08
bra HI_ISR
  
HI_ISR:
    bcf PIR1, TMR2IF
;    movlw D'122'
;    movwf PR2
    
    
    movlw 0x02
    cpfseq STATE
    goto NEXT
    movlw b'00001000'
    cpfseq PORTD
    goto NEXT
    movlw D'244'
    movwf PR2
    goto TURN
NEXT:
    
    movlw b'00010000'
    cpfslt PORTD
    goto CLEAR
    goto TURN
CLEAR:
    clrf PORTD
    bsf PORTD, 7
    
    incf STATE
    movlw 0x03
    cpfslt STATE
    clrf STATE

    movlw 0x00
    cpfseq STATE
    goto MODE1
MODE0:    
    movlw D'244'
    movwf PR2
    goto TURN
MODE1:
    movlw 0x01
    cpfseq STATE
    goto MODE2
    movlw D'122'
    movwf PR2
    goto TURN
MODE2:
    movlw D'61'
    movwf PR2

    
TURN:
    rlncf PORTD,F
    retfie FAST

INITIAL:
   clrf STATE
    
    call INIT_IO
    
    call INIT_TIMER2
    bsf RCON, IPEN
    bsf INTCON, GIEH
    
Main:
    goto Main

INIT_IO:
    movlw 0x0f ;configure A/D
    movwf ADCON1 ;set digital i/o
    
    clrf TRISD
    
    movlw 0x01
    movwf PORTD
    return
    
INIT_TIMER2:
    movlw b'01111111'
    movwf T2CON
    movlw D'244'
    movwf PR2
    bcf OSCCON, 6 ; 250kHz
    bsf OSCCON, 5
    bcf OSCCON, 4
    
    bsf IPR1, TMR2IP	;set timer2 high priority interrupt
    bcf PIR1, TMR2IF	;clear timer2 interrupt flag
    bsf PIE1, TMR2IE	;enable timer2 interrupt
    
    return

end

