
.segment "INPUT_BUFFER"
INPUT_BUFFER: .res $100

.segment "BIOS"

;Initialize the INPUT BUFFER

INIT_BUFFER:
  lda READ_PTR
  sta WRITE_PTR
  rts

;Write a byte to the INPUT BUFFER
;A register has value to write

WRITE_BUFFER:
  ldx WRITE_PTR
  sta INPUT_BUFFER, x
  inc WRITE_PTR
  rts

;Read byte from INPUT BUFFER
;A register contains value read

READ_BUFFER:
  ldx READ_PTR
  lda INPUT_BUFFER, x
  inc READ_PTR
  rts

;Computes the amount left to read
;A register contains the difference in WRITE_PTR - READ_PTR

BUFFER_DELTA:
  lda WRITE_PTR
  sec
  sbc READ_PTR
  rts

;Read a byte in from ACIA
;A register contains the value read

CHAR_IN:
  jsr BUFFER_DELTA
  beq @no_keypress
  jsr READ_BUFFER
  jsr CHAR_OUT ;echo
  pha
  jsr BUFFER_DELTA
  cmp #$E0
  bcs @buffer_full
  lda #$09
  sta ACIA_COMMAND
@buffer_full:
  pla
  sec
  rts
@no_keypress:
  clc
  rts

;Output the char in the A register to ACIA

CHAR_OUT:
  pha
  sta ACIA_DATA
  lda #$ff
@tx_wait:  
  dec
  bne @tx_wait
  pla
  rts

;Prints the hex value out from the A register
;Registers affected: A

PRINT_BYTE:
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

