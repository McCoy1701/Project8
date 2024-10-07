.CODE

MINI_ASSEMBLER:
  lda STORE_H
  jsr PRINT_BYTE
  lda STORE_L
  jsr PRINT_BYTE
  lda #$3A  ;':'
  jsr CHAR_OUT
  
  ldy #$00
@get_char:
  jsr CHAR_IN
  bcc @get_char
  sta BUFFER, y
  cmp #$08  ;backspace
  beq @backspace
  cmp #$1B  ;escape
  beq @escape
  cmp #$0D  ;'CR'
  beq @assemble
  iny
  bpl @get_char
  jmp ROM_SOFT_RESET

@escape:
  jmp ROM_SOFT_RESET

@backspace:
  cpy #$00
  beq @get_char
  dey
  jmp @get_char

@assemble:
  ldx #$00
  ldy #$00
@assemble_mnemonic:
  lda BUFFER, y
  jsr @capitalize
  cmp #'A'
  bmi @escape
  cmp #'Z'+1
  bpl @escape
  sta MNEMONIC, x
  iny
  inx
  cpx #$03
  bne @assemble_mnemonic

  jsr @get_opcode_from_table  ;Sets OP_INDEX from the mnemonic given
  jsr @check_for_accumulator_implied_relative_stack_addressing
  iny
  jsr @skip_spaces

@parse_operand:
  lda BUFFER, y
  cmp #$28  ;'('
  beq @indirect_am
  cmp #$23  ;'#'
  beq @immediate_am
  cmp #$24  ;'$'
  beq @jmp_operand_data  ;Sets absolute/zeropage addressing mode
  cmp #$0D  ;'CR'
  beq @jmp_fetch_opcode
  jmp ROM_SOFT_RESET

@jmp_operand_data:
  jmp @operand_data

@jmp_fetch_opcode:
  jmp @fetch_opcode

@indirect_am:
  iny
  lda BUFFER, y
  cmp #$24  ;'$'
  bne @escape
  iny
  jsr @parse_hex
  lda HEX_L
  sta OPERAND
  lda HEX_H
  sta OPERAND+1
  bne @absolute_indirect
  lda #AM_ZEROPAGE_INDIRECT
  sta ADDRESS_MODE
  jmp @check_indexed_indirect

@absolute_indirect:
  lda #AM_ABSOLUTE_INDIRECT
  sta ADDRESS_MODE

@check_indexed_indirect:
  lda BUFFER, y
  cmp #$2C  ;','
  bne @not_x_indexed
  lda ADDRESS_MODE
  cmp #AM_ABSOLUTE_INDIRECT
  bne @zeropage_indirect
  lda #AM_ABSOLUTE_INDEXED_INDIRECT
  sta ADDRESS_MODE
  jmp @finish_indexed_indirect

@zeropage_indirect:
  lda #AM_ZEROPAGE_INDEXED_INDIRECT
  sta ADDRESS_MODE

@finish_indexed_indirect:
  iny
  jsr @skip_spaces
  iny  ;skip 'x'
  iny  ;skip ')'
  jmp @parse_operand

@not_x_indexed:
  iny  ;skip ')'
  lda BUFFER, y
  cmp #$2C  ;','
  bne @not_y_indexed
  lda #AM_ZEROPAGE_INDIRECT_INDEXED
  sta ADDRESS_MODE
  iny ;skip ','
  jsr @skip_spaces
  iny ;skip 'y' should be at 'CR'

@not_y_indexed:
  jmp @parse_operand

;Pound sign was encountered
@immediate_am:
  iny
  lda #AM_IMMEDIATE
  sta ADDRESS_MODE
  lda BUFFER, y
  cmp #$24  ;'$'
  beq @hex_operand
  cmp #$25  ;'%'
  beq @binary_operand
  jmp ROM_SOFT_RESET  ; '#' should always be followed by a '$' or '%'

@hex_operand:
  iny  ;skip '$'
  jsr @parse_hex  ;Should leave y pointing to the 'CR'
  lda HEX_L
  sta OPERAND
  jmp @parse_operand

@binary_operand:
  iny  ;skip '%'
  jsr @parse_binary  ;Should leave y pointing at 'CR'
  lda HEX_L
  sta OPERAND
  jmp @parse_operand

@operand_data:
  iny
  jsr @parse_hex
  lda HEX_L
  sta OPERAND
  lda HEX_H
  sta OPERAND+1
  bne @set_absolute
  lda #AM_ZEROPAGE
  sta ADDRESS_MODE
  jmp @check_operand_indexed

@set_absolute:
  lda #AM_ABSOLUTE
  sta ADDRESS_MODE

@check_operand_indexed:
  lda BUFFER, y
  cmp #$2C  ;','
  bne @not_indexed
  iny
  jsr @skip_spaces
  lda BUFFER, y
  jsr @capitalize
  cmp #$58  ;'X'
  beq @x_indexed
  cmp #$59  ;'Y'
  beq @y_indexed
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
  iny
@not_indexed:
  jmp @parse_operand

@fetch_opcode:
  jmp ROM_SOFT_RESET

@get_opcode_from_table:
  ldx #$00  ;clear x, x will be the index into the menmonics table
  lda #<MNEMONICS  ;Load low-byte of mnemonics table
  sta TEMP0  ;Save it
  lda #>MNEMONICS  ;Load high-byte of mnemonics table
  sta TEMP0+1

@mnemonic_search:
  ldy #$00  ;clear y, index into buffer
  lda MNEMONIC, y
  cmp (TEMP0),y
  bne @next_mnemonic
  
  iny
  lda MNEMONIC, y
  cmp (TEMP0),y
  bne @next_mnemonic
  
  iny
  lda MNEMONIC, y
  cmp (TEMP0),y
  bne @next_mnemonic

  stx OP_INDEX
  rts

@next_mnemonic:
  inx
  clc
  lda TEMP0
  adc #$03
  sta TEMP0
  lda TEMP0+1
  adc #$00
  sta TEMP0+1

  lda TEMP0
  cmp #<MNEMONICS_END
  bne @mnemonic_search
  lda TEMP0+1
  cmp #>MNEMONICS_END
  bne @mnemonic_search

  lda #OP_UNK
  sta OP_INDEX
  rts

@check_for_accumulator_implied_relative_stack_addressing:
  lda OP_INDEX
  cmp #OP_ASL
  beq @accumulator
  cmp #OP_INC
  beq @accumulator
  cmp #OP_ROL
  beq @accumulator
  cmp #OP_DEC
  beq @accumulator
  cmp #OP_LSR
  beq @accumulator
  cmp #OP_ROR
  beq @accumulator

  cmp #OP_CLC
  beq @implied
  cmp #OP_SEC
  beq @implied
  cmp #OP_CLI
  beq @implied
  cmp #OP_SEI
  beq @implied
  cmp #OP_DEY
  beq @implied
  cmp #OP_TYA
  beq @implied
  cmp #OP_TAY
  beq @implied
  cmp #OP_CLV
  beq @implied
  cmp #OP_INY
  beq @implied
  cmp #OP_CLD
  beq @implied
  cmp #OP_INX
  beq @implied
  cmp #OP_SED
  beq @implied
  cmp #OP_NOP
  beq @implied
  cmp #OP_STP
  beq @implied
  cmp #OP_WAI
  beq @implied
  cmp #OP_DEX
  beq @implied
  cmp #OP_TSX
  beq @implied
  cmp #OP_TAX
  beq @implied
  cmp #OP_TXS
  beq @implied
  cmp #OP_TXA
  beq @implied
  
  cmp #OP_BPL
  beq @relative
  cmp #OP_BMI
  beq @relative
  cmp #OP_BVC
  beq @relative
  cmp #OP_BVS
  beq @relative
  cmp #OP_BRA
  beq @relative
  cmp #OP_BCC
  beq @relative
  cmp #OP_BCS
  beq @relative
  cmp #OP_BNE
  beq @relative
  cmp #OP_BEQ
  beq @relative
  cmp #OP_BBR
  beq @relative
  cmp #OP_BBS
  beq @relative

  cmp #OP_BRK
  beq @stack
  cmp #OP_RTI
  beq @stack
  cmp #OP_RTS
  beq @stack
  cmp #OP_PHP
  beq @stack
  cmp #OP_PLP
  beq @stack
  cmp #OP_PHA
  beq @stack
  cmp #OP_PLA
  beq @stack
  cmp #OP_PHY
  beq @stack
  cmp #OP_PLY
  beq @stack
  cmp #OP_PHX
  beq @stack
  cmp #OP_PLX
  beq @stack
  
  jmp @end_check  ;nothing checked out

@accumulator:
  lda #AM_ACCUMULATOR
  sta ADDRESS_MODE
  jmp @end_check

@implied:
  lda #AM_IMPLIED
  sta ADDRESS_MODE
  jmp @end_check

@relative:
  lda #AM_RELATIVE
  sta ADDRESS_MODE
  jmp @end_check

@stack:
  lda #AM_STACK
  sta ADDRESS_MODE

@end_check:
  rts

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

