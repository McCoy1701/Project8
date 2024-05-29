  .include "zeropage.inc"
  .include "via.inc"

  .export spi_send_instruction 
  .export spi_send_data

MOSI   = %00000010
LCD_CS = %00000100

  .code

spi_send_instruction:
  pha
  phx
  phy
  lda #LCD_CS                    ;Set chip select high
  sta PORTB
  
  ldy #5                    ;Start loop at 5
spi_sync_char:
  lda #( LCD_CS | MOSI )          ;Set mosi high
  sta PORTB
  
  inc PORTB                 ;Toggle SCLK
  dec PORTB
  
  dey
  bne spi_sync_char
  
  ldy #3
spi_rwl_rsl:
  lda #LCD_CS
  sta PORTB

  inc PORTB
  dec PORTB
  
  dey
  bne spi_rwl_rsl

  ldx #2
spi_send_nibble:
  ldy #4
spi_nibble:
  rol SPI_MOSI
  bcs spi_bit_high
  lda #LCD_CS
  sta PORTB
  
  inc PORTB
  dec PORTB
  
  jmp spi_dec_y
spi_bit_high:
  lda #( LCD_CS | MOSI )
  sta PORTB

  inc PORTB
  dec PORTB
spi_dec_y:
  dey
  bne spi_nibble

  ldy #4
spi_send_zeros:
  lda #LCD_CS
  sta PORTB
  inc PORTB
  dec PORTB
  dey
  bne spi_send_zeros
 
  dex
  bne spi_send_nibble

  stz PORTB
  ply
  plx
  pla
  rts

spi_send_data:
  pha
  phx
  phy
  lda #LCD_CS                    ;Set chip select high
  sta PORTB

  ldy #5                    ;Start loop at 5
spi_sync_char_1:
  lda #( LCD_CS | MOSI )          ;Set mosi high
  sta PORTB
  
  inc PORTB                 ;Toggle SCLK
  dec PORTB
  
  dey
  bne spi_sync_char_1

  lda #LCD_CS
  sta PORTB

  inc PORTB
  dec PORTB

  lda #( LCD_CS | MOSI )
  sta PORTB

  inc PORTB
  dec PORTB

  lda #LCD_CS
  sta PORTB

  inc PORTB
  dec PORTB

  ldx #2
spi_send_nibble_1:
  ldy #4
spi_nibble_1:
  rol SPI_MOSI
  bcs spi_bit_high_1
  lda #LCD_CS
  sta PORTB
  
  inc PORTB
  dec PORTB
  
  jmp spi_dec_y_1
spi_bit_high_1:
  lda #( LCD_CS | MOSI )
  sta PORTB

  inc PORTB
  dec PORTB
spi_dec_y_1:
  dey
  bne spi_nibble_1

  ldy #4
spi_send_zeros_1:
  lda #LCD_CS
  sta PORTB
  inc PORTB
  dec PORTB
  dey
  bne spi_send_zeros_1
 
  dex
  bne spi_send_nibble_1

  stz PORTB
  ply
  plx
  pla
  rts

