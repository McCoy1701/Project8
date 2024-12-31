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

@tracemon_input:
  jsr CHAR_IN
  bcc tracemon_input
  sta BUFFER, Y
  cmp #$73  ;'s'
  beq @single_step
  cmp #$66  ;'f'
  beq @free_run
  cmp #$62  ;'b'
  beq @set_breakpoint
  cmp #$1B  ;'esc'
  beq @escape
  iny
  bpl @tracemon_input
  jmp ROM_SOFT_RESET

@escape:
  jmp ROM_SOFT_RESET

@single_step:

@free_run:

@set_breakpoint:

TRACEMON_BUFFER:
  .res $03

