PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003

T1CL  = $6004
T1CH  = $6005
ACR   = $600b
IFR   = $600d
IER   = $600e

TICKS       = $0000 ;2bytes
TOGGLE_TIME = $0002 ;2bytes

B  = $0004 ;1byte
C  = $0005 ;1byte
D  = $0006 ;1byte

value   = $0200
mod10   = $0202
message = $0204

E     = %00000001
RW    = %00000010
RS    = %00000100

  .org $8000

reset:
  ldx #$ff                ;initialize the stack pointer to 1ff
  txs

  lda #$ff                ;Set port a to all outputs
  sta DDRA
  lda #$07                ;Set 3 bits of the msb of port b to outputs
  sta DDRB

  lda #%00111000                ;Set 8-bit mode, 1-line display, and 5x8 character font
  jsr toggle_enable
  lda #%00001110                ;Set display on, cursor on, cursor blinking off
  jsr toggle_enable
  lda #%00000110                ;Set entry mode
  jsr toggle_enable
  lda #%00000001                ;Clear display
  jsr toggle_enable
  lda #0
  sta TOGGLE_TIME
  jsr init_timer
  
  lda #4
  sta D
  lda #7
  sta C

  lda #0
  sta value
  sta value + 1

mutliply:
  lda #0                      ;Clear the A,B result high/low
  sta B
  ldx #8                      ;Set the x register to be used as a counter

mult_loop:
  lsr C                       ;Shift the multiplier into the carry bit
  bcc no_addr                 ;Branch to no addr when bit from multiplier is zero
  clc
  adc D                       ;Add multiplicand to result

no_addr:
  ror A
  ror B
  dex
  bne mult_loop

  sta value + 1
  lda B
  sta value
  
  jsr binary_to_decimal

  ldx #0
print_string:
  lda message, x
  beq loop
  jsr print_char
  inx
  jmp print_string

loop:
  ;sec
  ;lda TICKS
  ;sbc TOGGLE_TIME
  ;cmp #25
  ;bcc loop
  ;lda TICKS
  ;sta TOGGLE_TIME
  jmp loop

hello_world: .asciiz "Hello, World!"

binary_to_decimal:
  pha
  lda #0
  sta message

divide:
  lda #0                    ;Load a zero to mod10
  sta mod10
  sta mod10 + 1
  clc

  ldx #16
divloop:
  rol value                 ;Rotate value and mod10
  rol value + 1
  rol mod10
  rol mod10 + 1

  sec                       ;Set carry
  lda mod10                 ;Load a with mod10
  sbc #10                   ;Subtract 10
  tay                       ;Store the lower half in y
  lda mod10 + 1             ;Load the higher half
  sbc #0                    ;Subtract 0
  bcc ingore_result
  sty mod10                 ;Store the lower half back in mod10
  sta mod10 + 1             ;Store the higher half back in mod10

ingore_result:
  dex
  bne divloop
  rol value
  rol value + 1

  lda mod10
  clc
  adc #"0"
  jsr push_char

  lda value                 ;Check if value is zero
  ora value + 1
  bne divide
  pla
  rts

push_char:
  pha                       ;first char
  ldy #0

char_loop:
  lda message,y             ;Load the first byte of string
  tax                       
  pla                       ;Pull the new first char from the stack into a
  sta message,y             ;Store the new byte back into string
  iny
  txa
  pha                       ;Push char from string onto the stack
  bne char_loop

  pla                       ;Pull null terminator off and store it back to string
  sta message,y
  rts

lcd_check_busy:
  pha
  lda #$00
  sta DDRA
lcd_busy:
  lda #RW
  sta PORTB
  lda #( RW | E )
  sta PORTB
  lda PORTA
  and #%10000000
  bne lcd_busy

  lda #RW
  sta PORTB
  lda #$ff
  sta DDRA
  pla
  rts

toggle_enable:
  jsr lcd_check_busy
  sta PORTA
  lda #0
  sta PORTB
  lda #E
  sta PORTB
  lda #0
  sta PORTB
  rts

print_char:
  jsr lcd_check_busy
  sta PORTA
  lda #RS
  sta PORTB
  lda #( RS | E )
  sta PORTB
  lda #RS
  sta PORTB
  rts

init_timer:
  lda #0
  sta TICKS
  sta TICKS + 1
  sta TICKS + 2
  sta TICKS + 3
  lda #%01000000
  sta ACR
  lda #$0e
  sta T1CL
  lda #$27
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

