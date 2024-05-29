  .include "zeropage.inc"
  .include "via.inc"
  .include "via_consts.inc"

  .export delay
  .export init_timer
  
  .code

delay:
  pha
  delay_loop:
  sec
  lda TICKS
  sbc TOGGLE_TIME
  cmp #2
  bcc delay_loop
  lda TICKS
  sta TOGGLE_TIME
  pla
  rts

init_timer:
  lda #0
  sta TICKS
  sta TICKS + 1
  sta TICKS + 2
  sta TICKS + 3
  lda #ACR_T1_CONTINUOUS_NO_PB7
  sta VIA_ACR
  lda #$e6 ;03e6 = 998 270e = 9998
  sta VIA_T1CL
  lda #$03
  sta VIA_T1CH
  lda #( IER_SET_INTERRUPTS | IER_TIMER1 )
  sta VIA_IER
  cli
  rts

