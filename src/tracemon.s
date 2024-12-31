.segment "BREAKPOINT_LIST"
BREAKPOINT_LIST: .res $100

.CODE

;------------------------------;
;         Entry Point          ;
;------------------------------;

TRACEMON:
  lda #$00
  tax
  tay

@input_char:
  jsr CHAR_IN ;Get character
  bcc @input_char ;Carry will be set if there is a character
  sta BUFFER, y ;store char in buffer
  cmp #$08  ;Backspace?
  beq @backspace
  cmp #$1B  ;Escape?
  beq @escape
  cmp #$0D  ;CR?
  beq @processing
  iny
  bpl @input_char
  ldy #$04  ;buffer overflow
  jsr PRINT_ERROR
  jmp ROM_MONITOR  ;Overflowed the input buffer

@escape:
  jmp ROM_SOFT_RESET

@backspace:
  cpy #$00
  beq @input_char
  dey
  jmp @input_char

@processing:
  sty BUFFER_INDEX
  ldy #$00
  lda BUFFER, Y
  cmp #$73  ;'s'
  beq @single_step
  cmp #$66  ;'f'
  beq @free_run
  cmp #$62  ;'b'
  beq @set_breakpoint
  ldy #$01  ;No operand
  jsr PRINT_ERROR
  jmp ROM_SOFT_RESET

@single_step:
  jmp ROM_SOFT_RESET

@free_run:
  jmp ROM_SOFT_RESET

@set_breakpoint:
  jmp ROM_SOFT_RESET

TRACEMON_BUFFER:
  .res $03

