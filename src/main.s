.setcpu"65c02"

.include "lcd128.inc"
.include "utils.inc"

.segment"RESET_VECTORS"
  .word $0000
  .word reset
  .word irq_handler


  .code
reset:
  ldx #$ff                ;initialize the stack pointer to 1ff
  txs

  lda #0
  sta TOGGLE_TIME
  jsr init_timer
  
  lda #$ff                ;Set port a to all outputs
  sta VIA_DDRA
  lda #$07                ;Set 3 bits of the msb of port b to outputs
  sta VIA_DDRB

  jsr LCD_TEXT_MODE

  ldx #0
print_string:
  lda hello_world, x
  beq loop
  jsr print_char
  inx
  jmp print_string

loop:
  jmp loop

hello_world: .asciiz "Hello, World!"

irq_handler:
  bit T1CL
  inc TICKS
  bne end_irq
  inc TICKS + 1
  bne end_irq
  inc TICKS + 2
  bne end_irq
  inc TICKS + 3
end_irq:
  rti

