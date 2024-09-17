
BUFFER_INDEX = $B7
HEX_L        = $B8
HEX_H        = $B9
INDEX_L      = $BA
INDEX_H      = $BB
STORE_L      = $BC
STORE_H      = $BD
EXAMINE_L    = $BE
EXAMINE_H    = $BF

INPUT_BUFFER = $0200

.code

ROM_MONITOR:
  lda #$6F  ;'o'
  jsr CHAR_OUT
  lda #$6B  ;'k'
  jsr CHAR_OUT

@soft_reset:
  php  ;Come back from user code so print register will work
  phy
  phx
  pha
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
  beq @escape
  cmp #$0D  ;CR?
  beq @enter
  iny
  bpl @input_char
  jmp ROM_MONITOR  ;Overflowed the input buffer

@escape:
  jmp @soft_reset

@backspace:
  cpy #$00
  beq @input_char
  dey
  jmp @input_char

@enter:
  ldy #$00   ;Zero registers
  lda #$00
  tax

@parse_character_loop:
  lda INPUT_BUFFER, y
  cmp #$0D  ;'CR'
  beq @soft_reset  ;Finished with this line
  cmp #$77  ;'w'
  beq @JMP_WRITE
  cmp #$72  ;'r'
  beq @JMP_READ
  cmp #$61  ;'a'
  beq @JMP_SET_ADDRESS
  cmp #$6f  ;'o'
  beq @JMP_PRINT_ADDRESSES
  cmp #$62  ;'b'
  beq @JMP_BLOCK_EXAMINE
  cmp #$52  ;'R'
  beq @JMP_PRINT_REGISTERS
  cmp #$78  ;'x'
  beq @JMP_EXECUTE
  jmp ROM_MONITOR  ;Something bad happened

@JMP_WRITE:
  jmp @write

@JMP_READ:
  jmp @read

@JMP_SET_ADDRESS:
  jmp @set_address

@JMP_PRINT_ADDRESSES:
  jmp @print_addresses

@JMP_BLOCK_EXAMINE:
  jmp @block_examine

@JMP_PRINT_REGISTERS:
  jmp @print_registers

@JMP_EXECUTE:
  jmp @execute

@write:
  iny

@write_loop:
  jsr @skip_spaces
  jsr @parse_hex
  lda HEX_L
  sta (STORE_L)

  lda INPUT_BUFFER, y
  cmp #$0D  ;'CR'
  beq @write_done

  inc STORE_L
  bne @jmp_write_loop
  inc STORE_H

@jmp_write_loop:
  jmp @write_loop

@write_done:
  jmp @parse_character_loop

;Read n bytes from the address in examine

@read:
  iny  ;current index is at 'r'
  jsr @skip_spaces
  jsr @parse_hex  ;get the hex value after r command
  lda #$00  ;Set zero flag first time through
  sta INDEX_L
  sta INDEX_H

@print_new_line:
  jsr @print_examine

  lda INDEX_H
  cmp HEX_H
  bne @continue_reading

  lda INDEX_L
  cmp HEX_L
  beq @done_reading

@continue_reading:
  inc INDEX_L
  inc EXAMINE_L
  bne @no_read_count_wrap
  inc INDEX_H
  inc EXAMINE_H

@no_read_count_wrap:
  jmp @print_new_line

@done_reading:
  jmp @parse_character_loop


;Set the current, store, examine address
;Returns the new addsess in CURRENT, STORE, EXAMINE
;Registers affected: A, X, Y, HEX_L, HEX_H, CURRENT_L, CURRENT_H, STORE_L, STORE_H, EXAMINE_L, EXAMINE_H, INPUT_BUFFER

@set_address:
  iny
  jsr @skip_spaces
  jsr @parse_hex

  lda HEX_L
  sta INDEX_L
  sta STORE_L
  sta EXAMINE_L

  lda HEX_H
  sta INDEX_H
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

  lda (EXAMINE_L)
  jsr @print_byte

  jmp @parse_character_loop

;Print the addresses out EXAMINE, STORE, CURRENT

@print_addresses:
  iny
  lda #$0D
  jsr CHAR_OUT

  ldx #$00
@print_examine_str:
  lda @examine_str,x
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
@print_index_str:
  lda @index_str,x
  beq @done_index_print
  jsr CHAR_OUT
  inx
  jmp @print_index_str

@done_index_print:
  lda #$20
  jsr CHAR_OUT
  lda INDEX_H
  jsr @print_byte
  lda INDEX_L
  jsr @print_byte

  lda #$0D
  jsr CHAR_OUT
  
  ldx #$00
@print_store_str:
  lda @store_str,x
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

  jmp @parse_character_loop

;Examine a block of address from hex value to hex value

@block_examine:
  iny
  jsr @skip_spaces
  jsr @parse_hex
  lda HEX_L
  sta EXAMINE_L
  lda HEX_H
  sta EXAMINE_H
  
  jsr @skip_spaces
  jsr @parse_hex
  lda HEX_L
  sta INDEX_L
  lda HEX_H
  sta INDEX_H
  
  lda #$00  ;Set zero flag first time through

@print_new_block_line:
  jsr @print_examine

  lda EXAMINE_H
  cmp INDEX_H
  bne @continue_reading_block

  lda EXAMINE_L
  cmp INDEX_L
  beq @done_reading_block

@continue_reading_block:
  inc EXAMINE_L
  bne @no_examine_wrap
  inc EXAMINE_H

@no_examine_wrap:
  jmp @print_new_block_line

@done_reading_block:
  jmp @parse_character_loop

;Print out all the registers
;A, X, Y, Stack, Flags

@print_registers:
  iny
  lda #$0D
  jsr CHAR_OUT
  lda #$41  ;'A'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  pla  ;A should be last on stack from soft reset
  jsr @print_byte
  
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda #$58  ;'X'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  pla  ;X should be next
  jsr @print_byte
  
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda #$59  ;'Y'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  pla  ;Y should be next
  jsr @print_byte
  
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda #$53  ;'S'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  tsx
  txa
  jsr @print_byte
  
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda #$46  ;'F'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  pla  ;Flags are last
  jsr @print_byte

  jmp @parse_character_loop

;Start executing code at this location

@execute:
  jmp (EXAMINE_L)

;Print out the location of examine, and its contents.

@print_examine:
  lda EXAMINE_L
  and #$07
  bne @print_examine_data
  lda #$0D  ;'CR'
  jsr CHAR_OUT
  lda EXAMINE_H
  jsr @print_byte
  lda EXAMINE_L
  jsr @print_byte
  lda #$3A  ;':'
  jsr CHAR_OUT

@print_examine_data:
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda (EXAMINE_L)
  jsr @print_byte
  rts

;Parses hex value from input buffer until non hex (0-9,A-F) is found
;Returns the hex values found from input buffer in HEX_L, HEX_H
;Registers affected: A, Y, X, INPUT_BUFFER, HEX_L, HEX_H

@parse_hex:
  lda #$00
  sta HEX_L
  sta HEX_H
  sty BUFFER_INDEX

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
  cpy BUFFER_INDEX  ;Y = INDEX means found no hex values
  beq @hard_reset  ;Hard reset before shit breaks
  rts

@hard_reset:
  jmp ROM_MONITOR

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
  bcc @jmp_char_out  ;Print digits
  adc #$06
  jsr CHAR_OUT  ;Print Hex values
  rts

@jmp_char_out:
  jmp CHAR_OUT

@examine_str: .asciiz "Examine:"
@store_str:   .asciiz "Store:"
@index_str:   .asciiz "Index:"
