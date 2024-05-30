MOSI   = %00000010
LCD_CS = %00000100

.segment "LCD"

spi_send_instruction:
  pha
  phx
  phy
  lda #LCD_CS                    ;Set chip select high
  sta VIA_PORTB
  
  ldy #5                    ;Start loop at 5
@spi_sync_char:
  lda #( LCD_CS | MOSI )          ;Set mosi high
  sta VIA_PORTB
  
  inc VIA_PORTB                 ;Toggle SCLK
  dec VIA_PORTB
  
  dey
  bne @spi_sync_char
  
  ldy #3
@spi_rwl_rsl:
  lda #LCD_CS
  sta VIA_PORTB

  inc VIA_PORTB
  dec VIA_PORTB
  
  dey
  bne @spi_rwl_rsl

  ldx #2
@spi_send_nibble:
  ldy #4
@spi_nibble:
  rol SPI_MOSI
  bcs @spi_bit_high
  lda #LCD_CS
  sta VIA_PORTB
  
  inc VIA_PORTB
  dec VIA_PORTB
  
  jmp @spi_dec_y
@spi_bit_high:
  lda #( LCD_CS | MOSI )
  sta VIA_PORTB

  inc VIA_PORTB
  dec VIA_PORTB
@spi_dec_y:
  dey
  bne @spi_nibble

  ldy #4
@spi_send_zeros:
  lda #LCD_CS
  sta VIA_PORTB
  inc VIA_PORTB
  dec VIA_PORTB
  dey
  bne @spi_send_zeros
 
  dex
  bne @spi_send_nibble

  stz VIA_PORTB
  ply
  plx
  pla
  rts

spi_send_data:
  pha
  phx
  phy
  lda #LCD_CS                    ;Set chip select high
  sta VIA_PORTB

  ldy #5                    ;Start loop at 5
@spi_sync_char:
  lda #( LCD_CS | MOSI )          ;Set mosi high
  sta VIA_PORTB
  
  inc VIA_PORTB                 ;Toggle SCLK
  dec VIA_PORTB
  
  dey
  bne @spi_sync_char

  lda #LCD_CS
  sta VIA_PORTB

  inc VIA_PORTB
  dec VIA_PORTB

  lda #( LCD_CS | MOSI )
  sta VIA_PORTB

  inc VIA_PORTB
  dec VIA_PORTB

  lda #LCD_CS
  sta VIA_PORTB

  inc VIA_PORTB
  dec VIA_PORTB

  ldx #2
@spi_send_nibble:
  ldy #4
@spi_nibble:
  rol SPI_MOSI
  bcs @spi_bit_high
  lda #LCD_CS
  sta VIA_PORTB
  
  inc VIA_PORTB
  dec VIA_PORTB
  
  jmp @spi_dec_y
@spi_bit_high:
  lda #( LCD_CS | MOSI )
  sta VIA_PORTB

  inc VIA_PORTB
  dec VIA_PORTB
@spi_dec_y:
  dey
  bne @spi_nibble

  ldy #4
@spi_send_zeros:
  lda #LCD_CS
  sta VIA_PORTB
  inc VIA_PORTB
  dec VIA_PORTB
  dey
  bne @spi_send_zeros
 
  dex
  bne @spi_send_nibble

  stz VIA_PORTB
  ply
  plx
  pla
  rts

