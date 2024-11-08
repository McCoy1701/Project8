
.segment "GAMES"

INIT_PRNG:
  lda $4000  ;should hold random value from restart
  sta SEED
  rts

PRNG:
  lda SEED
  lsr
  bcc @no_eor
  eor #$B8

@no_eor:
  sta SEED
  rts

