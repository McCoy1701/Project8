
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
  beq @end_of_disassembly
  jmp @was_FF

@not_FF:
  stz FF_COUNTER  ;Not 4 $FF in a row
@was_FF:
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
  beq @get_word
  cmp #$02  ;AM_ABSOLUTE_INDEXED_X
  beq @get_word
  cmp #$03  ;AM_ABSOLUTE_INDEXED_Y
  beq @get_word
  cmp #$04  ;AM_ABSOLUTE_INDIRECT      
  beq @get_word
  
  cmp #$05  ;AM_IMMEDIATE
  beq @get_byte
  cmp #$06  ;AM_ACCUMULATOR
  beq @implied
  cmp #$07  ;AM_IMPLIED
  beq @implied
  cmp #$08  ;AM_STACK
  beq @implied
  cmp #$09  ;AM_RELATIVE
  beq @implied
  
  cmp #$0A  ;AM_ZEROPAGE
  beq @get_byte
  cmp #$0B  ;AM_ZEROPAGE_INDEXED_INDIRECT
  beq @get_byte
  cmp #$0C  ;AM_ZEROPAGE_INDEXED_X
  beq @get_byte
  cmp #$0D  ;AM_ZEROPAGE_INDEXED_Y
  beq @get_byte
  cmp #$0E  ;AM_ZEROPAGE_INDIRECT
  beq @get_byte
  cmp #$0F  ;AM_ZEROPAGE_INDIRECT_INDEXED
  beq @get_byte

  lda OPERAND + 1
  cmp #$00
  bne @operand_is_word
  lda OPERAND
  cmp #$00
  bne @operand_is_byte
  jmp @done

@operand_is_word:
  lda #$24  ;'$'
  jsr CHAR_OUT

  lda OPERAND+1
  jsr PRINT_BYTE
  lda OPERAND
  jsr PRINT_BYTE
  jmp @done

@operand_is_byte:
  lda #$24  ;'$'
  jsr CHAR_OUT

  lda OPERAND
  jsr PRINT_BYTE

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
  beq @get_word
  cmp #$01  ;AM_ABSOLUTE_INDEXED_INDIRECT
  beq @get_word
  cmp #$02  ;AM_ABSOLUTE_INDEXED_X
  beq @get_word
  cmp #$03  ;AM_ABSOLUTE_INDEXED_Y
  beq @get_word
  cmp #$04  ;AM_ABSOLUTE_INDIRECT      
  beq @get_word
  
  cmp #$05  ;AM_IMMEDIATE
  beq @get_byte
  cmp #$06  ;AM_ACCUMULATOR
  beq @implied
  cmp #$07  ;AM_IMPLIED
  beq @implied
  cmp #$08  ;AM_STACK
  beq @implied
  cmp #$09  ;AM_RELATIVE
  beq @implied
  
  cmp #$0A  ;AM_ZEROPAGE
  beq @get_byte
  cmp #$0B  ;AM_ZEROPAGE_INDEXED_INDIRECT
  beq @get_byte
  cmp #$0C  ;AM_ZEROPAGE_INDEXED_X
  beq @get_byte
  cmp #$0D  ;AM_ZEROPAGE_INDEXED_Y
  beq @get_byte
  cmp #$0E  ;AM_ZEROPAGE_INDIRECT
  beq @get_byte
  cmp #$0F  ;AM_ZEROPAGE_INDIRECT_INDEXED
  beq @get_byte
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

