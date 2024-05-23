MPDAD  = $0000 ;1byte
MPRAD  = $0001 ;1byte
RESULT = $0002 ;2bytes
TEMP   = $0004 ;1byte

B      = $0005 ;1byte
C      = $0006 ;1byte
D      = $0007 ;1byte

  .org $8000                  ;Where program execution starts

reset:
  lda #0                      ;Clear the result memory and temp
  sta RESULT
  sta RESULT + 1
  sta TEMP
  ldx #8                      ;Set the x register to be used as a counter

mutliply:
  lsr MPRAD                   ;Shift the multiplier into the carry bit
  bcc no_addr                 ;Branch to no addr when bit from multiplier is zero
  lda RESULT                  ;Load the result into a
  clc
  adc MPDAD                   ;Add multiplicand to result
  sta RESULT
  lda RESULT + 1
  adc TEMP
  sta RESULT + 1

no_addr:
  asl MPDAD
  rol temp
  dex
  bne multiply

mutliply:
  lda #0                      ;Clear the A,B result high/low
  sta B
  ldx #8                      ;Set the x register to be used as a counter

mult_loop:
  lsr C                       ;Shift the multiplier into the carry bit
  bcc no_addr                 ;Branch to no addr when bit from multiplier is zero
  clc
  adc D                       ;Add multiplicand to result

no_addr:
  ror A
  ror B
  dex
  bne mult_loop

  .org  $fffa                 ;Setting the vectors
  .word $0000                 ;Non-Maskable Interrupt
  .word reset                 ;Reset Vector
  .word $0000                 ;Interrupt Request

