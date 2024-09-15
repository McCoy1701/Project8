
EXAMINE_H    = $BF
EXAMINE_L    = $BD
STORE_H      = $BC
STORE_L      = $BB
CURRENT_H    = $BA
CURRENT_L    = $B9
READ_COUNT_H = $B8
READ_COUNT_L = $B7
HEX_H        = $B6
HEX_L        = $B5
INDEX        = $B4
MODE         = $B3

INPUT_BUFFER = $0200

.code

ROM_MONITOR:
  lda #$6F  ;'o'
  jsr CHAR_OUT
  lda #$6B  ;'k'
  jsr CHAR_OUT

@soft_reset:
  lda #$0D  ;'CR'
  jsr CHAR_OUT

  ldy #$00  ;Initialize index into input buffer
@input_char:
  jsr CHAR_IN ;Get character
  bcc @input_char ;Carry will be set if there is a character
  sta INPUT_BUFFER, y ;store char in buffer
  cmp #$08  ;Backspace?
  beq @backspace
  cmp #$1B  ;Escape?
  beq ROM_MONITOR
  cmp #$0D  ;CR?
  beq @enter
  iny
  bpl @input_char
  jmp ROM_MONITOR  ;Overflowed the input buffer

@backspace:
  cpy #$00
  beq @input_char
  dey
  lda #$08  ;backspace
  jsr CHAR_OUT
  jmp @input_char

@enter:
  sty INDEX  ;Store the index into the input buffer

  ldy #$00   ;Zero registers
  lda #$00
  tax

  lda INPUT_BUFFER, y
  cmp #$0D  ;'CR'
  beq @soft_reset
  cmp #$77  ;'w'
  beq @write
  cmp #$72  ;'r'
  beq @read
  cmp #$61  ;'a'
  beq @set_address
  cmp #$6f  ;'o'
  beq @print_addresses
  cmp #$62  ;'b'
  beq @block_examine
  cmp #$52  ;'R'
  beq @print_registers
  cmp #$78  ;'x'
  beq @execute
  jmp ROM_MONITOR  ;Something Bad Happened

@write:
  jmp @soft_reset

@read:
  iny  ;current index is at 'r'
  jsr @skip_spaces
  jsr @parse_hex  ;get the hex value after r command
  lda #$00  ;Set zero flag first time through

@print_new_line:
  bne @print_data
  lda #$0D  ;'CR'
  jsr CHAR_OUT
  lda EXAMINE_H
  jsr @print_byte
  lda EXAMINE_L
  jsr @print_byte
  lda #$3A  ;':'
  jsr CHAR_OUT

@print_data:
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda (EXAMINE_L, x)
  jsr @print_byte

  lda READ_COUNT_H
  cmp HEX_H
  bne @continue_reading

  lda READ_COUNT_L
  cmp HEX_L
  beq @done_reading

@continue_reading:
  inc READ_COUNT_L
  inc EXAMINE_L
  bne @mod_8_check
  inc READ_COUNT_H
  inc EXAMINE_H

@mod_8_check:
  lda EXAMINE_L
  and #$07
  jmp @print_new_line

@done_reading:
  jmp @soft_reset


;Set the current, store, examine address
;Returns the new addsess in CURRENT, STORE, EXAMINE
;Registers affected: A, X, Y, HEX_L, HEX_H, CURRENT_L, CURRENT_H, STORE_L, STORE_H, EXAMINE_L, EXAMINE_H, INPUT_BUFFER

@set_address:
  iny
  jsr @skip_spaces
  jsr @parse_hex

  lda HEX_L
  sta CURRENT_L
  sta STORE_L
  sta EXAMINE_L

  lda HEX_H
  sta CURRENT_H
  sta STORE_H
  sta EXAMINE_H

  lda #$0D  ;'CR'
  jsr CHAR_OUT

  lda HEX_H
  jsr @print_byte

  lda HEX_L
  jsr @print_byte

  lda #$3A  ;':'
  jsr CHAR_OUT

  lda #$20  ;'Space'
  jsr CHAR_OUT

  lda (EXAMINE_L, x)
  jsr @print_byte

  jmp @soft_reset

@print_addresses:
  lda #$0D
  jsr CHAR_OUT

  ldx #$00
@print_examine_str:
  lda @examine_str
  beq @done_examine_print
  jsr CHAR_OUT
  inx
  jmp @print_examine_str

@done_examine_print:
  lda #$20
  jsr CHAR_OUT
  lda EXAMINE_H
  jsr @print_byte
  lda EXAMINE_L
  jsr @print_byte

  lda #$0D
  jsr CHAR_OUT

  ldx #$00
@print_current_str:
  lda @current_str
  beq @done_current_print
  jsr CHAR_OUT
  inx
  jmp @print_current_str

@done_current_print:
  lda #$20
  jsr CHAR_OUT
  lda CURRENT_H
  jsr @print_byte
  lda CURRENT_L
  jsr @print_byte

  lda #$0D
  jsr CHAR_OUT
  
  ldx #$00
@print_store_str:
  lda @current_str
  beq @done_store_print
  jsr CHAR_OUT
  inx
  jmp @print_store_str

@done_store_print:
  lda #$20
  jsr CHAR_OUT
  lda STORE_H
  jsr @print_byte
  lda STORE_L
  jsr @print_byte
  
  jmp @soft_reset

@block_examine:
  jmp @soft_reset

@print_registers:
  jmp @soft_reset


;Parses hex value from input buffer until non hex (0-9,A-F) is found
;Returns the hex values found from input buffer in HEX_L, HEX_H
;Registers affected: A, Y, X, INPUT_BUFFER, HEX_L, HEX_H

@parse_hex:
  lda #$00
  sta HEX_L
  sta HEX_H
  sty INDEX

@get_hex:
  lda INPUT_BUFFER, y
  eor #$30  ;Map ascii digits to 0->9hexit
  cmp #$0A  ;Digit
  bcc @digit
  adc #$A8  ;Map ascii letters a->f to $FA->$FF
  cmp #$FA
  bcc @not_hex

@digit:
  asl
  asl
  asl
  asl
  ldx #$04

@hex_shift:
  asl
  rol HEX_L
  rol HEX_H
  dex
  bne @hex_shift
  iny
  jmp @get_hex

@not_hex:
  cpy INDEX  ;Y = INDEX means found no hex values
  beq ROM_MONITOR  ;Hard reset before shit breaks
  rts

;Skips spaces encountered in the input buffer
;Registers affected: A, Y, INPUT_BUFFER

@skip_spaces:
  lda INPUT_BUFFER, y
  cmp #$20  ;space
  beq @do_skip  ;Skip over space
  rts
@do_skip:
  iny
  jmp @skip_spaces

;Prints the hex value out from the A register
;Registers affected: A

@print_byte:
  pha
  lsr
  lsr
  lsr
  lsr
  jsr @print_hex
  pla

@print_hex:
  and #$0F
  ora #$30
  cmp #$3A
  bcc CHAR_OUT  ;Print digits
  adc #$06
  jsr CHAR_OUT  ;Print Hex values
  rts

@examine_str: .asciiz "Examine:"
@store_str:   .asciiz "Store:"
@current_str: .asciiz "Current:"

