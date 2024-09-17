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
.include "wozmon.s"

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

  ldx #0
out_string:
  lda hello_world, x
  beq here
  jsr CHAR_OUT
  inx
  jmp out_string

here:
  ldx #0
print_string:
  lda hello_world, x
  beq LOOP
  jsr print_char
  inx
  jmp print_string

LOOP:
  jmp WOZMON

hello_world: .asciiz "Hello, World!"

irq_handler:
  bit VIA_T1CL
  inc TICKS
  bne @end_irq
  inc TICKS + 1
  bne @end_irq
  inc TICKS + 2
  bne @end_irq
  inc TICKS + 3
@end_irq:
  rti

.include "rom_monitor.s"
