.setcpu"65c02"

.segment"RESET_VECTORS"
  .word $0000
  .word reset
  .word irq_handler

.include "zeropage.s"
.include "via.s"

.include "utils.s"
.include "spi_lcd128.s"
.include "lcd128.s"

.code

.proc reset
  ldx #$ff                ;initialize the stack pointer to 1ff
  txs

  lda #0
  sta TOGGLE_TIME
  jsr init_timer
  
  lda #$ff                ;Set port a to all outputs
  sta VIA_DDRA
  lda #$07                ;Set 3 bits of the msb of port b to outputs
  sta VIA_DDRB

  jsr lcd_text_mode
  jmp main 
.endproc

.proc main
  ldx #0
print_string:
  lda hello_world, x
  beq loop
  jsr print_char
  inx
  jmp print_string

loop:
  jmp loop
.endproc

hello_world: .asciiz "Hello, World!"

.proc irq_handler
  bit VIA_T1CL
  inc TICKS
  bne end_irq
  inc TICKS + 1
  bne end_irq
  inc TICKS + 2
  bne end_irq
  inc TICKS + 3
end_irq:
  rti
.endproc

