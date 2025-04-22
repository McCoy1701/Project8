.segment "UTILS"

;Delay x amount of milliseconds from 1 - 255
;Registers affected: A, X

DELAY:
  pha
  stx DELAY_TICKS  ;Store delay value (1-255)
  lda TICKS
  sta DELTA_TICKS

@delay_loop:
  sec
  lda TICKS
  sbc DELTA_TICKS
  cmp DELAY_TICKS
  bcc @delay_loop
  pla
  rts

TIMER_INITIALIZE:
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

