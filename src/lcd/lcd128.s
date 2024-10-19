
;BASIC INSTRUCTION SET
DISPLAY_CLEAR                = %00000001
RETURN_HOME                  = %00000010

ENTRY_MODE_DEC_NO_SHIFT      = %00000100
ENTRY_MODE_DEC_SHIFT_RIGHT   = %00000101
ENTRY_MODE_INC_NO_SHIFT      = %00000110
ENTRY_MODE_INC_SHIFT_LEFT    = %00000111

DISPLAY_CTRL_DISPLAY_CURSOR_BLINK_OFF = %00001000
DISPLAY_CTRL_DISPLAY_ON               = %00001100
DISPLAY_CTRL_DISPLAY_CURSOR_ON        = %00001110
DISPLAY_CTRL_DISPLAY_CURSOR_BLINK_ON  = %00001111

CURSOR_DISPLAY_SHIFT_CTRL_CURSOR_LEFT  = %00010000
CURSOR_DISPLAY_SHIFT_CTRL_CURSOR_RIGHT = %00010100

CURSOR_DISPLAY_SHIFT_CTRL_DISPLAY_LEFT  = %00011000
CURSOR_DISPLAY_SHIFT_CTRL_DISPLAY_RIGHT = %00011100

FUNCTION_SET_8BIT_BASIC    = %00110000
FUNCTION_SET_4BIT_BASIC    = %00100000

;EXTENDED FUNCTIONS

STANDBY = %00000001

FUNCTION_SET_8BIT_EXTENDED = %00110100
FUNCTION_SET_4BIT_EXTENDED = %00100100
FUNCTION_SET_8BIT_EXTENDED_GRAPHICS = %00110110
FUNCTION_SET_4BIT_EXTENDED_GRAPHICS = %00100110

SET_SCROLL_ADDR      = %01000000
SET_GRAPHIC_RAM_ADDR = %10000000

.segment "LCD"

print_char:
  sta SPI_MOSI
  jsr spi_send_data
  jsr delay
  rts

lcd_initialize:
  pha
  lda #FUNCTION_SET_4BIT_BASIC    ;Set 8-bit mode, 1-line display, and 5x8 character font
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay

  lda #DISPLAY_CTRL_DISPLAY_CURSOR_ON     ;Set display on, cursor on, cursor blinking off
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  
  lda #ENTRY_MODE_INC_NO_SHIFT            ;Set entry mode
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  
  lda #DISPLAY_CLEAR                      ;Clear display
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  pla
  rts

lcd_text_mode:
  pha
  lda #FUNCTION_SET_4BIT_BASIC    ;Set 4-bit mode
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay

  lda #DISPLAY_CLEAR
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  
  lda #RETURN_HOME
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  
  pla
  rts

lcd_graphics_mode:
  pha
  lda #FUNCTION_SET_4BIT_EXTENDED
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay

  lda #FUNCTION_SET_4BIT_EXTENDED_GRAPHICS
  sta SPI_MOSI
  jsr spi_send_instruction
  jsr delay
  
  pla
  rts
