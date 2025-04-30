.segment "BREAKPOINT_LIST"
BREAKPOINT_LIST: .res $100

.CODE

;------------------------------;
;         Entry Point          ;
;------------------------------;
TRACEMON:
  stz BREAKPOINT_COUNTER
  stz TRACEMON_BUFFER_INDEX
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

disassemble_current_instruction:
  lda (EXAMINE_L)
  jsr FETCH_OP_INDEX
  jsr GET_MNEMONIC
  jsr GET_OPERAND
  rts

load_tracemon_buffer:
  lda OPERAND
  beq @no_operand
  lda OPERAND+1
  beq @not_word
  ldy #$00
  sty TRACEMON_BUFFER_INDEX
  jmp @continue
  
@no_operand:
  ldy #$02  ;set index into TRACEMON_BUFFER
  sty TRACEMON_BUFFER_INDEX
  jmp @continue

@not_word:
  ldy #$01
  sty TRACEMON_BUFFER_INDEX

@continue:
  ldx #$00

@buffer_load_loop:
  lda OPCODE, x
  sta TRACEMON_BUFFER, y
  cpy #$02
  beq @done_load_loop
  iny
  inx
  jmp @buffer_load_loop

@done_load_loop:
  rts

execute_buffer:
  clc
  lda #<TRACEMON_BUFFER
  adc TRACEMON_BUFFER_INDEX
  sta EXECUTION_ADDRESS
  lda #>TRACEMON_BUFFER
  adc #$00
  sta EXECUTION_ADDRESS+1
  jmp (EXECUTION_ADDRESS)


TRACEMON_BUFFER:
  .res $02

