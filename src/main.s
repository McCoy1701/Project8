PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003

T1CL  = $6004
T1CH  = $6005
ACR   = $600b
IFR   = $600d
IER   = $600e

TICKS       = $00fc ;4bytes top of zero page
TOGGLE_TIME = $00fb ;1byte

SPI_MOSI = $00fa ;1byte
SPI_MISO = $00f9 ;1byte

MOSI   = %00000010
LCD_CS = %00000100

  .org $8000

reset:
  ldx #$ff                ;initialize the stack pointer to 1ff
  txs

  lda #0
  sta TOGGLE_TIME
  jsr init_timer
  
  lda #$ff                ;Set port a to all outputs
  sta DDRA
  lda #$07                ;Set 3 bits of the msb of port b to outputs
  sta DDRB

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

print_char:
  sta SPI_MOSI
  jsr spi_send_data
  jsr delay
  rts

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

delay:
  pha
  delay_loop:
  sec
  lda TICKS
  sbc TOGGLE_TIME
  cmp #2
  bcc delay_loop
  lda TICKS
  sta TOGGLE_TIME
  pla
  rts

init_timer:
  lda #0
  sta TICKS
  sta TICKS + 1
  sta TICKS + 2
  sta TICKS + 3
  lda #%01000000
  sta ACR
  lda #$e6 ;03e6 = 998 270e = 9998
  sta T1CL
  lda #$03
  sta T1CH
  lda #%11000000
  sta IER
  cli
  rts

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

  .org $fffa
  .word $0000
  .word reset
  .word irq_handler

