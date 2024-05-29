  .include "zeropage.inc"
  .include "utils.inc"

  .import spi_send_instruction
  .import spi_send_data
  .export print_char
  .export lcd_text_mode

  .code
print_char:
  sta SPI_MOSI
  jsr spi_send_data
  jsr delay
  rts

lcd_text_mode:
  pha
  lda #%00100000                ;Set 8-bit mode, 1-line display, and 5x8 character font
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay

  lda #%00001110                ;Set display on, cursor on, cursor blinking off
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  
  lda #%00000110                ;Set entry mode
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  
  lda #%00000001                ;Clear display
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  pla
  rts
