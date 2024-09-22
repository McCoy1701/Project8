
.segment "BIOS"

CHAR_IN:
  lda ACIA_STATUS
  and #$08
  beq @no_keypress
  lda ACIA_DATA
  jsr CHAR_OUT ;echo
  sec
  rts
@no_keypress:
  clc
  rts

;Output the char in the A register

CHAR_OUT:
  pha
  sta ACIA_DATA
  lda #$ff
@tx_wait:  
  dec
  bne @tx_wait
  pla
  rts

;Prints the hex value out from the A register
;Registers affected: A

PRINT_BYTE:
  pha
  lsr
  lsr
  lsr
  lsr
  jsr @print_hex
  pla

@print_hex:
  and #$0F
  ora #$30
  cmp #$3A
  bcc CHAR_OUT  ;Print digits
  adc #$06
  jsr CHAR_OUT  ;Print Hex values
  rts

