
.segment "BIOS"

IRQ_HANDLER:
  sta IRQ_SAVE_A
  pla
  pha
  and #$10
  beq @not_break

  plp
  pla
  pla
  lda IRQ_SAVE_A
  jmp ROM_SOFT_RESET
  
@not_break:
  lda IRQ_SAVE_A
  pha
  phx
  phy

  lda ACIA_STATUS
  bpl @not_acia
  lda ACIA_DATA
  jsr WRITE_BUFFER
  jsr BUFFER_DELTA
  cmp #$F0
  bcc @end_irq
  lda #$01
  sta ACIA_COMMAND
  jmp @end_irq

@not_acia:
  lda VIA_IFR
  bpl @end_irq
  and VIA_IER
  asl
  bmi @service_timer_1
  asl
  bmi @service_timer_2
  asl
  bmi @service_cb_1
  asl
  bmi @service_cb_2
  asl
  bmi @service_SR
  asl
  bmi @service_ca_1
  asl
  bmi @service_ca_2
  jmp @end_irq ;shouldn't get to here, but just in case

@service_timer_1:
  lda VIA_T1CL  ;Preforms a read on T1CL effectively reseting it
  inc TICKS
  bne @end_irq
  inc TICKS + 1
  bne @end_irq
  inc TICKS + 2
  bne @end_irq
  inc TICKS + 3
  jmp @end_irq

@service_timer_2:
@service_cb_1:
@service_cb_2:
@service_SR:
@service_ca_1:
@service_ca_2:

@end_irq:
  ply
  plx
  pla
  rti

