
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

CHAR_OUT:
  pha
  sta ACIA_DATA
  lda #$ff
@tx_wait:  
  dec
  bne @tx_wait
  pla
  rts

