
TEST_INDEX = $00

.CODE

ZEROPAGE_TEST:
  ldy #$00
  sty TEST_INDEX
  sty TEST_INDEX+1

@zp_check_loop:
  lda #$AA
  sta (TEST_INDEX), Y
  lda (TEST_INDEX), Y
  cmp #$AA
  beq @zp_success

  pha
  lda TEST_INDEX+1
  jsr PRINT_BYTE
  lda TEST_INDEX
  jsr PRINT_BYTE
  txa
  jsr PRINT_BYTE
  lda #$3A  ;':'
  jsr CHAR_OUT
  lda #$20  ;'space'
  jsr CHAR_OUT
  pla
  jsr PRINT_BYTE

@zp_success:
  lda #$00
  sta (TEST_INDEX), Y
  iny
  bne @done_zp_check
  jmp @zp_check_loop

@done_zp_check:
  rts

STACK_TEST:

RAM_TEST:

