
.segment "UTILS"

MEMORY_TEST:
  pha
  phx
  phy

  ldy #$00  ;LSB for start address TODO: make this load from a memory location in zeropage
  sty START_INDEX
  ldx #$04
  stx START_INDEX + 1
  
  lda START_INDEX
  sta WRITE_INDEX

  lda START_INDEX + 1
  sta WRITE_INDEX + 1

  lda #$AA
  sta TEST_PATTERN

@ram_check_loop:
  lda TEST_PATTERN  ;Test pattern TODO: make this use a memory location in zeropage so multiple patterns can be tested
  sta (WRITE_INDEX)
  lda (WRITE_INDEX)
  cmp TEST_PATTERN
  beq @ram_success

  pha
  lda WRITE_INDEX + 1
  jsr PRINT_BYTE
  lda WRITE_INDEX
  jsr PRINT_BYTE
  lda #$3A  ;':'
  jsr CHAR_OUT
  lda #$20  ;'space'
  jsr CHAR_OUT
  pla  ;what byte was read instead of pattern
  jsr PRINT_BYTE
  jmp @done_ram_check

@ram_success:
  lda #$FF
  sta (WRITE_INDEX)

  iny
  sty WRITE_INDEX
  bne @done_page_check
  inx
  stx WRITE_INDEX + 1

@done_page_check:
  cpx #$40
  bne @ram_check_loop
  cpy #$00
  beq @done_ram_check
  jmp @ram_check_loop

@done_ram_check:
  ldx #$00
@print_finish_str:
  lda @finished_str, x
  beq @done_finished_print
  jsr CHAR_OUT
  inx
  jmp @print_finish_str

@done_finished_print:
  lda #$0d  ;'CR'
  jsr CHAR_OUT

  lda #$55
  sta RAM_TEST
  
  ply
  plx
  pla
  
  rts

@finished_str: .asciiz "MEMORY CHECKED"

