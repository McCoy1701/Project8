
; TODO: read byte at store address, if byte is $FF increment ff_counter, else set ff_counter to zero (This keeps track if we hit the end of code),
; index into the opcode table that amount, get the mnemonic and addressing mode, output mnemonic if there is one along with operand, skip necessary
; bytes if there is operand data this will leave it pointing at the next opcode to disassemble jump back to the next byte to read.

.CODE

;------------------------------;
;         Entry Point          ;
;------------------------------;

MINI_DISASSEMBLER:
  stz FF_COUNTER  ;Zero everything out
  stz OP_INDEX
  stz ADDRESS_MODE
  stz MNEMONIC
  stz MNEMONIC+1
  stz MNEMONIC+2
  stz OPCODE
  stz OPERAND
  stz OPERAND+1
  lda #$00
  tax
  tay

@disassembler_loop:
  lda EXAMINE_H
  jsr PRINT_BYTE
  lda EXAMINE_L
  jsr PRINT_BYTE
  lda #$3A  ;':'
  jsr CHAR_OUT

@read_byte_from_store:
  lda (EXAMINE_L)
  cmp #$FF
  bne @not_FF
  inc FF_COUNTER
  lda FF_COUNTER
  cmp #$04
  beq @jmp_end_of_disassembly
  jmp @was_FF

@jmp_end_of_disassembly:
  jmp @end_of_disassembly

@not_FF:
  stz FF_COUNTER  ;Not 4 $FF in a row
@was_FF:
  lda (EXAMINE_L)
  jsr @fetch_op_index
  jsr @get_mnemonic
  jsr @get_operand

  lda #$20  ;' 'space
  jsr CHAR_OUT

  ldx #$00
@menmonic_print:
  lda MNEMONIC, X
  jsr CHAR_OUT
  inx
  cpx #$03
  bne @menmonic_print
  
  lda #$20  ;' 'space
  jsr CHAR_OUT

  lda ADDRESS_MODE
  cmp #AM_ABSOLUTE ; TODO: change this to use a range instead of checking every one
  beq @operand_is_word
  cmp #AM_ABSOLUTE_INDEXED_INDIRECT
  beq @jmp_indexed_indirect
  cmp #AM_ABSOLUTE_INDEXED_X
  beq @jmp_absolute_indexed_x
  cmp #AM_ABSOLUTE_INDEXED_Y
  beq @jmp_absolute_indexed_y ;here
  cmp #AM_INDIRECT
  beq @jmp_absolute_indirect
  
  cmp #AM_IMMEDIATE
  beq @jmp_immediate
  cmp #AM_ACCUMULATOR
  bmi @not_implied
  cmp #AM_RELATIVE
  bpl @not_implied
  jmp @am_implied

@not_implied:
  cmp #AM_RELATIVE
  beq @operand_is_byte

  cmp #AM_ZEROPAGE
  beq @operand_is_byte
  cmp #AM_ZEROPAGE_INDEXED_INDIRECT
  beq @jmp_zeropage_indexed_indirect
  cmp #AM_ZEROPAGE_INDEXED_X
  beq @jmp_zeropage_indexed_x
  cmp #AM_ZEROPAGE_INDEXED_Y
  beq @jmp_zeropage_indexed_y
  cmp #AM_ZEROPAGE_INDIRECT
  beq @jmp_zeropage_indirect
  cmp #AM_ZEROPAGE_INDIRECT_INDEXED
  beq @jmp_zeropage_indirect_indexed
  cmp #AM_UNKNOWN
  beq @jmp_done

@jmp_indexed_indirect:
  jmp @indexed_indirect

@jmp_absolute_indexed_x:
  jmp @absolute_indexed_x

@jmp_absolute_indexed_y:
  jmp @absolute_indexed_y

@jmp_absolute_indirect:
  jmp @absolute_indirect

@jmp_immediate:
  jmp @immediate

@jmp_zeropage_indexed_indirect:
  jmp @zeropage_indexed_indirect

@jmp_zeropage_indexed_x:
  jmp @zeropage_indexed_x

@jmp_zeropage_indexed_y:
  jmp @zeropage_indexed_y

@jmp_zeropage_indirect:
  jmp @zeropage_indirect

@jmp_zeropage_indirect_indexed:
  jmp @zeropage_indirect_indexed

@jmp_done:
  jmp @done

@operand_is_word:
  jsr @print_word_operand
  jmp @done

@operand_is_byte:
  jsr @print_byte_operand
  jmp @done

@indexed_indirect:
  lda #$28  ;'('
  jsr CHAR_OUT
  jsr @print_word_operand
  lda #$2C  ;','
  jsr CHAR_OUT
  lda #$20  ;' 'space
  jsr CHAR_OUT
  lda #$58  ;'X'
  jsr CHAR_OUT
  lda #$29  ;')'
  jsr CHAR_OUT
  jmp @done

@absolute_indexed_x:
  jsr @print_word_operand
  lda #$2C  ;','
  jsr CHAR_OUT
  lda #$20  ;' 'space
  jsr CHAR_OUT
  lda #$58  ;'X'
  jsr CHAR_OUT
  jmp @done

@absolute_indexed_y:
  jsr @print_word_operand
  lda #$2C  ;','
  jsr CHAR_OUT
  lda #$20  ;' 'space
  jsr CHAR_OUT
  lda #$59  ;'Y'
  jsr CHAR_OUT
  jmp @done

@absolute_indirect:
  lda #$28  ;'('
  jsr CHAR_OUT
  jsr @print_word_operand
  lda #$29  ;')'
  jsr CHAR_OUT
  jmp @done

@immediate:
  lda #$23  ;'#'
  jsr CHAR_OUT
  jsr @print_byte_operand
  jmp @done

@am_implied:
  jmp @done

@zeropage_indexed_indirect:
  lda #$28  ;'('
  jsr CHAR_OUT
  jsr @print_byte_operand
  lda #$2C  ;','
  jsr CHAR_OUT
  lda #$20  ;' 'space
  jsr CHAR_OUT
  lda #$58  ;'X'
  jsr CHAR_OUT
  lda #$29  ;')'
  jsr CHAR_OUT
  jmp @done

@zeropage_indexed_x:
  jsr @print_byte_operand
  lda #$2C  ;','
  jsr CHAR_OUT
  lda #$20  ;' 'space
  jsr CHAR_OUT
  lda #$58  ;'X'
  jsr CHAR_OUT
  jmp @done

@zeropage_indexed_y:
  jsr @print_byte_operand
  lda #$2C  ;','
  jsr CHAR_OUT
  lda #$20  ;' 'space
  jsr CHAR_OUT
  lda #$59  ;'Y'
  jsr CHAR_OUT
  jmp @done

@zeropage_indirect:
  lda #$28  ;'('
  jsr CHAR_OUT
  jsr @print_byte_operand
  lda #$29  ;')'
  jsr CHAR_OUT
  jmp @done

@zeropage_indirect_indexed:
  lda #$28  ;'('
  jsr CHAR_OUT
  jsr @print_byte_operand
  lda #$29  ;')'
  jsr CHAR_OUT
  lda #$2C  ;','
  jsr CHAR_OUT
  lda #$20  ;' 'space
  jsr CHAR_OUT
  lda #$59  ;'Y'
  jsr CHAR_OUT

@done:
  lda #$0D  ;'CR'
  jsr CHAR_OUT
  
  jsr @increment_examine
  jmp @disassembler_loop

;------------------------------;
;          Exit Point          ;
;------------------------------;

@end_of_disassembly:
  jmp ROM_SOFT_RESET

;------------------------------------------;
; Get the operand from disassembled opcode ;
;------------------------------------------;

@get_operand:
  stz OPERAND
  stz OPERAND+1
  lda ADDRESS_MODE
  cmp #$00  ;AM_ABSOLUTE  TODO: change this to use a range instead of checking every one
  bmi @not_word
  cmp #$04  ;AM_ABSOLUTE_INDIRECT
  bpl @not_word
  jmp @get_word

@not_word: 
  cmp #$05  ;AM_IMMEDIATE
  beq @get_byte
  cmp #$06  ;AM_ACCUMULATOR
  bmi @not_am_implied
  cmp #$09  ;AM_RELATIVE
  bpl @not_am_implied
  jmp @implied

@not_am_implied:
  cmp #$09  ;AM_RELATIVE
  bmi @not_get_byte
  cmp #$10  ;AM_ZEROPAGE_INDIRECT_INDEXED
  bpl @not_get_byte
  jmp @get_byte

@not_get_byte:
  jmp @get_operand_done

@get_word:
  jsr @increment_examine
  lda (EXAMINE_L)
  sta OPERAND
  jsr @increment_examine
  lda (EXAMINE_L)
  sta OPERAND + 1
  jmp @get_operand_done

@get_byte:
  jsr @increment_examine
  lda (EXAMINE_L)
  sta OPERAND

@implied:

@get_operand_done:
  rts

;------------------------------;
;                              ;
;------------------------------;

@increment_examine:
  inc EXAMINE_L
  bne @increment_done
  inc EXAMINE_H
@increment_done:
  rts

;--------------------------------;
; Gets ASCII values for mnemonic ;
;--------------------------------;

@get_mnemonic:
  stz MNEMONIC
  stz MNEMONIC+1
  stz MNEMONIC+2
  
  ldx #$00  ;clear x, x will be the index into the mnemonics table
  lda #<MNEMONICS  ;Load low-byte of mnemonics table
  sta TEMP_WORD0  ;Save it
  lda #>MNEMONICS  ;Load high-byte of mnemonics table
  sta TEMP_WORD0+1

@mnemonic_search:
  cpx OP_INDEX
  bne @next_mnemonic

  ldy #$00
  lda (TEMP_WORD0), Y
  sta MNEMONIC, Y
  
  iny
  lda (TEMP_WORD0), Y
  sta MNEMONIC, Y
  
  iny
  lda (TEMP_WORD0), Y
  sta MNEMONIC, Y
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

  ldy #$00
  lda #$85  ;'U'
  sta MNEMONIC, Y

  iny
  lda #$75  ;'N'
  sta MNEMONIC, Y

  iny
  lda #$78  ;'K'
  sta MNEMONIC, Y
  rts

;-------------------------------;
; Gets the OP_INDEX from opcode ;
;-------------------------------;

@fetch_op_index:
  sta OPCODE  ;Put a into opcode

  lda #<OPCODES
  sta TEMP_WORD1
  lda #>OPCODES
  sta TEMP_WORD1+1

  ldx #$00  ;Current index into OPCODES
  ldy #$00

@opcode_search:
  cpx OPCODE
  bne @next_opcode
  
  lda (TEMP_WORD1), Y
  sta OP_INDEX

  iny
  lda (TEMP_WORD1), Y
  sta ADDRESS_MODE
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
  sta OP_INDEX
  lda #AM_UNKNOWN
  sta ADDRESS_MODE
  rts

@print_word_operand:
  lda #$24  ;'$'
  jsr CHAR_OUT

  lda OPERAND+1
  jsr PRINT_BYTE
  lda OPERAND
  jsr PRINT_BYTE
  rts

@print_byte_operand:
  lda #$24  ;'$'
  jsr CHAR_OUT

  lda OPERAND
  jsr PRINT_BYTE
  rts

