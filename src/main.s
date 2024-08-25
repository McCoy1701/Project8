.setcpu"65c02"

.segment"RESET_VECTORS"
  .word $0000
  .word reset
  .word irq_handler

.include "zeropage.s"
.include "via.s"
.include "acia.s"

.include "utils.s"
.include "spi_lcd128.s"
.include "lcd128.s"

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

  lda #00                 ;Soft reset for the ACIA
  sta ACIA_STATUS

  lda #$1f                ;1stopbit, 8bit word len, baud rate 19,200
  sta ACIA_CONTROL

  lda #$0b                ;Odd parity, parity disabled, receiver normal mode, RTSB = low, disabled, irq disabled, data terminal ready
  sta ACIA_COMMAND
  
  ldx #0
print_string:
  lda hello_world, x
  beq acia_wait
  jsr print_char
  inx
  jmp print_string

acia_wait:
  lda ACIA_STATUS
  and #$08
  beq acia_wait

  lda ACIA_DATA
  jsr print_char
  jmp acia_wait

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

