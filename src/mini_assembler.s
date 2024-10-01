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
  jsr @get_opcode_from_table

@get_opcode_from_table:

