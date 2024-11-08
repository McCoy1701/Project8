.setcpu"65c02"
.debuginfo

.segment "RESET_VECTORS"
  .word $0000
  .word reset
  .word IRQ_HANDLER

.include "zeropage.s"
.include "via.s"
.include "acia.s"

.include "bios.s"
.include "utils.s"
.include "lcd/spi_lcd128.s"
.include "lcd/lcd128.s"

.include "sd_card/sd_commands.s"
.include "sd_card/sd_spi.s"
.include "sd_card/sd_basic_read_write.s"

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

.include "irq_handler.s"
.include "rom_monitor.s"
.include "mnemonics_table.s"
.include "mini_assembler.s"

.include "memory_test.s"
.include "games/blackjack.s"
.include "games/pseudo_random_number_generator.s"

