.segment "LABEL_LIST"
LABEL_LIST: .res $100

.CODE

;------------------------------;
;        Entry Point           ;
;------------------------------;

MINI_ASSEMBLER:
  lda STORE_H  ;Print starting location of assembler
  jsr PRINT_BYTE
  lda STORE_L
  jsr PRINT_BYTE
  lda #$3A  ;':'
  jsr CHAR_OUT
  
  ldy #$00  ;Zero index into text buffer

@get_char:
  jsr CHAR_IN  ;Wait for input from the user
  bcc @get_char
  sta BUFFER, y
  cmp #$08  ;backspace
  beq @backspace
  cmp #$1B  ;escape
  beq @escape
  cmp #$0D  ;'CR'
  beq @assemble
  iny
  bpl @get_char  ;Buffer overflows when bit 7 is set
  jmp ROM_SOFT_RESET

@escape:  ;Escape backs out to memory monitor
  jmp ROM_SOFT_RESET

@backspace:  ;Decrements the index into the text buffer so the last byte can be rewritten
  cpy #$00
  beq @get_char
  dey
  jmp @get_char

;------------------------------;
; Start of the Assembly Process;
;------------------------------;

@assemble:
  ldx #$00  ;X is the count of how many characters have been stored into MNEMONIC
  ldy #$00  ;Reset index into text buffer

@assemble_mnemonic:
  lda BUFFER, y
  jsr @capitalize  ;coverts lowercase into uppercase
  cmp #'A'  ;Checking if it is actually a uppercase letter
  bmi @escape ;If not just reset to memory monitor
  cmp #'Z'+1
  bpl @escape
  sta MNEMONIC, x  ;If it is an uppercase letter between 'A - Z+1'
  iny
  inx
  cpx #$03
  bne @assemble_mnemonic

  jsr @get_opcode_from_table  ;Sets OP_INDEX from the mnemonic given
  iny
  jsr @skip_spaces
  jsr @check_for_accumulator_implied_relative_stack_addressing

;------------------------------------;
; Parse data after assembly mnemonic ;
;------------------------------------;

@parse_operand:
  lda BUFFER, y
  cmp #$28  ;'('
  beq @indirect_am
  cmp #$23  ;'#'
  beq @immediate_am
  cmp #$24  ;'$'
  beq @jmp_operand_data  ;Sets absolute/zeropage addressing mode
  cmp #$22  ;'"'
  beq @jmp_label_add
  cmp #$0D  ;'CR'
  beq @jmp_assemble_opcode
  jmp ROM_SOFT_RESET

@jmp_operand_data:
  jmp @operand_data

@jmp_label_add:
  jmp @label_add

@jmp_assemble_opcode:
  jmp @assemble_opcode

;------------------------------;
; Addressing mode is Indirect  ;
;------------------------------;

@indirect_am:
  iny  ;Increment past open parenthesis
  lda BUFFER, y
  cmp #$24  ;'$'
  bne @escape  ;Make sure there is a hex number
  iny  ;Increment past the dollar sign
  jsr @parse_hex  ;Get the hex values store them to operand
  lda HEX_L
  sta OPERAND
  lda HEX_H
  sta OPERAND+1
  bne @absolute_indirect  ;If just a byte was parse then addressing mode is zeropage
  lda #AM_ZEROPAGE_INDIRECT
  sta ADDRESS_MODE
  jmp @check_indexed_indirect

@absolute_indirect:
  lda #AM_INDIRECT
  sta ADDRESS_MODE

@check_indexed_indirect:
  lda BUFFER, y
  cmp #$2C  ;',' can only be x indexed if , is before the close parenthesis
  bne @not_x_indexed
  lda ADDRESS_MODE
  cmp #AM_INDIRECT
  bne @zeropage_indirect  ;Check if it's zeropage or absolute 
  lda #AM_ABSOLUTE_INDEXED_INDIRECT
  sta ADDRESS_MODE
  jmp @finish_indexed_indirect

@zeropage_indirect:
  lda #AM_ZEROPAGE_INDEXED_INDIRECT
  sta ADDRESS_MODE

@finish_indexed_indirect:
  iny  ;skip ','
  jsr @skip_spaces
  iny  ;skip 'x'
  iny  ;skip ')'
  jmp @parse_operand  ;Done with indexed indirect addressing mode parse_operand will jmp to assemble_opcode

@not_x_indexed:
  iny  ;skip ')'
  lda BUFFER, y
  cmp #$2C  ;',' can only be y indexed if comma is after close parenthesis
  bne @not_y_indexed
  lda #AM_ZEROPAGE_INDIRECT_INDEXED
  sta ADDRESS_MODE
  iny ;skip ','
  jsr @skip_spaces
  iny ;skip 'y' should be at 'CR'

@not_y_indexed:
  jmp @parse_operand

;------------------------------;
; Addressing mode is immediate ;
;------------------------------;

@immediate_am:
  iny  ;Increment past '#'
  lda #AM_IMMEDIATE
  sta ADDRESS_MODE
  lda BUFFER, y
  cmp #$24  ;'$'
  beq @hex_operand
  cmp #$25  ;'%'
  beq @binary_operand
  ldy #$01
  jsr @print_error
  jmp ROM_SOFT_RESET  ; '#' should always be followed by a '$' or '%'

@hex_operand:
  iny  ;skip '$'
  jsr @parse_hex  ;Should leave y pointing to the 'CR'
  lda HEX_L
  sta OPERAND
  stz OPERAND+1
  jmp @parse_operand

@binary_operand:
  iny  ;skip '%'
  jsr @parse_binary  ;Should leave y pointing at 'CR'
  lda HEX_L
  sta OPERAND
  stz OPERAND+1
  jmp @parse_operand

;-----------------------------------;
; Addressing mode absolute/zeropage ; 
;-----------------------------------;

@operand_data:
  iny  ;Increment past '$'
  jsr @parse_hex
  lda HEX_L
  sta OPERAND
  lda HEX_H
  sta OPERAND+1
  bne @set_absolute  ;If HEX_H is 0 then it's zeropage addressing
  lda #AM_ZEROPAGE
  sta ADDRESS_MODE
  stz OPERAND+1
  jmp @check_operand_indexed

@set_absolute:
  lda #AM_ABSOLUTE
  sta ADDRESS_MODE

@check_operand_indexed:
  lda BUFFER, y
  cmp #$2C  ;','
  bne @not_indexed
  iny  ;Increment past comma
  jsr @skip_spaces
  lda BUFFER, y
  jsr @capitalize
  cmp #$58  ;'X'
  beq @x_indexed
  cmp #$59  ;'Y'
  beq @y_indexed
  ldy #$02
  jsr @print_error
  jmp ROM_SOFT_RESET ;Shouldn't get here

@x_indexed:
  lda ADDRESS_MODE
  cmp #AM_ABSOLUTE
  bne @zeropage_x_indexed
  lda #AM_ABSOLUTE_INDEXED_X
  sta ADDRESS_MODE
  jmp @finish_indexed

@zeropage_x_indexed:
  lda #AM_ZEROPAGE_INDEXED_X
  sta ADDRESS_MODE
  jmp @finish_indexed

@y_indexed:
  lda ADDRESS_MODE
  cmp #AM_ABSOLUTE
  bne @zeropage_y_indexed
  lda #AM_ABSOLUTE_INDEXED_Y
  sta ADDRESS_MODE
  jmp @finish_indexed

@zeropage_y_indexed:
  lda #AM_ZEROPAGE_INDEXED_Y
  sta ADDRESS_MODE

@finish_indexed:
  iny  ;Increment past X/Y
@not_indexed:
  jmp @parse_operand

;------------------------------;
; Find the Opcode and write it ;
;------------------------------;


@assemble_opcode:
  jsr @fetch_opcode  ;Use the Mnemonic to find the opcode

  lda OPCODE
  cmp #OP_UNK  ;Make sure it was able to find a valid opcode
  beq @wrong_opcode_addressing_mode
  lda ADDRESS_MODE
  cmp #AM_UNKNOWN
  bne @write_opcode

@wrong_opcode_addressing_mode:
  ldy #$03
  jsr @print_error
  jmp ROM_SOFT_RESET

@write_opcode:
  lda OPCODE
  sta (STORE_L)
  jsr @inc_store
  
  lda ADDRESS_MODE  ;Check if addressing mode is between accumulator and stack
  cmp #AM_ACCUMULATOR
  bmi @has_operand
  cmp #AM_STACK+1
  bpl @has_operand
  jmp MINI_ASSEMBLER  ;Finish for accumulator/implied/stack addressing modes

@has_operand:
  lda OPERAND
  sta (STORE_L)
  jsr @inc_store

  lda OPERAND+1  ;65c02 is little endian
  bne @store_operand_lsb
  jmp MINI_ASSEMBLER  ;End of assembler

@store_operand_lsb:
  sta (STORE_L)
  jsr @inc_store
  jmp MINI_ASSEMBLER

;------------------------------;
; Increment store position     ;
;------------------------------;

@inc_store:
  inc STORE_L
  bne @no_store_wrap
  inc STORE_H
@no_store_wrap:
  rts

;---------------------------------------------------------;
; Search for opcode with opcode index and addressing mode ;
;---------------------------------------------------------;

@fetch_opcode:
  ldx #$00
  lda #<OPCODES
  sta TEMP_WORD1
  lda #>OPCODES
  sta TEMP_WORD1+1

@opcode_search:
  ldy #$00
  lda OP_INDEX
  cmp (TEMP_WORD1), y
  bne @next_opcode
  
  iny
  lda ADDRESS_MODE
  cmp (TEMP_WORD1), y
  bne @next_opcode

  stx OPCODE
  rts

@next_opcode:
  inx
  clc
  lda TEMP_WORD1
  adc #$02
  sta TEMP_WORD1
  lda TEMP_WORD1+1
  adc #$00
  sta TEMP_WORD1+1

  lda TEMP_WORD1
  cmp #<OPCODES_END
  bne @opcode_search
  lda TEMP_WORD1+1
  cmp #>OPCODES_END
  bne @opcode_search

  lda #OP_UNK
  sta OPCODE
  lda #AM_UNKNOWN
  sta ADDRESS_MODE
  rts

;----------------------------------------------;
; Searches for opcode index in mnemonics table ;
;----------------------------------------------;

@get_opcode_from_table:
  ldx #$00  ;clear x, x will be the index into the mnemonics table
  lda #<MNEMONICS  ;Load low-byte of mnemonics table
  sta TEMP_WORD0  ;Save it
  lda #>MNEMONICS  ;Load high-byte of mnemonics table
  sta TEMP_WORD0+1

@mnemonic_search:
  ldy #$00  ;clear y, index into buffer
  lda MNEMONIC, y
  cmp (TEMP_WORD0),y
  bne @next_mnemonic
  
  iny
  lda MNEMONIC, y
  cmp (TEMP_WORD0),y
  bne @next_mnemonic
  
  iny
  lda MNEMONIC, y
  cmp (TEMP_WORD0),y
  bne @next_mnemonic

  stx OP_INDEX
  rts

@next_mnemonic:
  inx
  clc
  lda TEMP_WORD0
  adc #$03
  sta TEMP_WORD0
  lda TEMP_WORD0+1
  adc #$00
  sta TEMP_WORD0+1

  lda TEMP_WORD0
  cmp #<MNEMONICS_END
  bne @mnemonic_search
  lda TEMP_WORD0+1
  cmp #>MNEMONICS_END
  bne @mnemonic_search

  lda #OP_UNK
  sta OP_INDEX
  rts

;------------------------------;
;                              ;
;------------------------------;

@check_for_accumulator_implied_relative_stack_addressing:
  lda OP_INDEX
  cmp #OP_ASL
  bmi @not_accumulator  ;Less than OP_ASL
  cmp #OP_INC+1
  bpl @not_accumulator  ;Greater than OP_INC

@accumulator:
  lda #AM_ACCUMULATOR
  sta ADDRESS_MODE
  jmp @end_check

@not_accumulator:
  cmp #OP_CLC
  bmi @not_implied  ;Less than OP_CLC
  cmp #OP_STP+1
  bpl @not_implied  ;Greater than OP_STP

@implied:
  lda #AM_IMPLIED
  sta ADDRESS_MODE
  jmp @end_check

@not_implied:  
  cmp #OP_BPL
  bmi @not_relative
  cmp #OP_BBS+1
  bpl @not_relative

@relative:
  lda #AM_RELATIVE
  sta ADDRESS_MODE
  lda BUFFER, y
  cmp #$24  ;'$'
  beq @get_relative_address
  ldy #$01  ;No operand
  jsr @print_error
  jmp ROM_SOFT_RESET

@get_relative_address:
  iny
  jsr @parse_hex
  
  cld
  sec
  
  lda HEX_L
  sbc STORE_L
  sta TEMP_WORD2
  
  lda HEX_H
  sbc STORE_H
  sta TEMP_WORD2+1

  lda TEMP_WORD2  ;don't count the opcode and data in the branch
  sbc #$02
  sta TEMP_WORD2

  lda TEMP_WORD2+1
  sbc #$00
  sta TEMP_WORD2+1

  cmp #$FF
  beq @valid_range
  cmp #$00
  beq @valid_range
  ldy #$04
  jsr @print_error
  jmp ROM_SOFT_RESET

@valid_range:
  lda TEMP_WORD2
  sta OPERAND
  jmp @end_check

@not_relative:
  cmp #OP_BRK
  bmi @end_check
  cmp #OP_PLX+1
  bpl @end_check

@stack:
  lda #AM_STACK
  sta ADDRESS_MODE

@end_check:
  rts

;--------------------------------;
; Add a label to the label table ;
;--------------------------------;

@label_add:
  jmp ROM_SOFT_RESET

;Capitalize ascii character in A register
;Registers affected: A

@capitalize:
  cmp #'a'
  bmi @not_lowercase  ;Less than 'a' $61
  cmp #'z'+1
  bpl @not_lowercase  ;Greater than 'z' + 1 $7B
  and #%11011111  ;Clear the 5th bit
@not_lowercase:
  rts

;Parses hex value from input buffer until non hex (0-9,A-F) is found
;Returns the hex values found from input buffer in HEX_L, HEX_H
;Registers affected: A, Y, X

@parse_hex:
  lda #$00
  sta HEX_L
  sta HEX_H
  sty BUFFER_INDEX

@get_hex:
  lda BUFFER, y
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
  jmp MINI_ASSEMBLER

;Parse buffer for binary digits and stores them into HEX_L
;Registers affected: A, Y

@parse_binary:
  lda #$00
  sta HEX_L
  sta HEX_H
  sty BUFFER_INDEX

@get_binary:
  lda BUFFER, y
  eor #$30  ;Map ascii digits to 0->1 binary digit
  cmp #$02  ;Digit
  bcs @not_binary_digit

  asl  ;move lsb all the way over to msb
  asl
  asl
  asl
  asl
  asl
  asl

  asl  ;move bit 7 into carry
  rol HEX_L  ;store digit in hex
  iny
  jmp @get_binary

@not_binary_digit:
  cpy BUFFER_INDEX
  beq @hard_reset
  rts

;Skips spaces encountered in the input buffer
;Registers affected: A, Y

@skip_spaces:
  lda BUFFER, y
  cmp #$20  ;space
  beq @do_skip  ;Skip over space
  rts
@do_skip:
  iny
  jmp @skip_spaces

@print_error:
  ldx #$00
@print_error_str:
  lda @error_str,x
  beq @done_error_print
  jsr CHAR_OUT
  inx
  jmp @print_error_str

@done_error_print:
  tya
  jsr PRINT_BYTE
  rts

@error_str: .asciiz "syntax error: "

