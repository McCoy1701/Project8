.setcpu"65c02"
.debuginfo

.segment"RESET_VECTORS"
  .word $0000
  .word reset
  .word irq_handler

.include "zeropage.s"
.include "via.s"
.include "acia.s"

.include "bios.s"
.include "utils.s"
.include "lcd/spi_lcd128.s"
.include "lcd/lcd128.s"
;.include "wozmon.s"

.code

reset:
  ldx #$ff                ;initialize the stack pointer to 1ff
  txs

  lda #0
  sta TOGGLE_TIME         ;Continuous timer at 1000 clk cycles
  jsr init_timer
  
  lda #$ff                ;Set port a to all outputs
  sta VIA_DDRA
  lda #$07                ;Set 3 bits of the msb of port b to outputs
  sta VIA_DDRB

  jsr lcd_initialize
  jsr ACIA_INITIALIZE

  jmp ROM_MONITOR

irq_handler:
  pha
  phx
  phy
  lda VIA_IFR
  bpl @not_via
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
  jmp @end_irq ;should get to here, but just in case

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

@not_via:
  php
  pla
  asl
  asl
  asl
  bmi @return_to_monitor

@end_irq:
  ply
  plx
  pla
  rti

@return_to_monitor:
  ply
  plx
  pla
  jmp ROM_SOFT_RESET

.include "rom_monitor.s"
