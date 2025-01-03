.segment "ROM_BUFFER"
BUFFER: .res $100

.CODE

ROM_MONITOR:
  lda #$6F  ;'o'
  jsr CHAR_OUT
  lda #$6B  ;'k'
  jsr CHAR_OUT

ROM_SOFT_RESET:
  php  ;Come back from user code so print register will work
  phy
  phx
  pha
  lda #$0D  ;'CR'
  jsr CHAR_OUT

  ldy #$00  ;Initialize index into input buffer
@input_char:
  jsr CHAR_IN ;Get character
  bcc @input_char ;Carry will be set if there is a character
  sta BUFFER, y ;store char in buffer
  cmp #$08  ;Backspace?
  beq @backspace
  cmp #$1B  ;Escape?
  beq @escape
  cmp #$0D  ;CR?
  beq @enter
  iny
  bpl @input_char
  ldy #$04  ;Overflow
  jsr PRINT_ERROR
  jmp ROM_MONITOR  ;Overflowed the input buffer

@escape:
  jmp ROM_SOFT_RESET

@backspace:
  cpy #$00
  beq @input_char
  dey
  jmp @input_char

@enter:
  ldy #$00   ;Zero registers
  lda #$00
  tax

@parse_character_loop:
  lda BUFFER, y
  cmp #$0D  ;'CR'
  beq ROM_SOFT_RESET  ;Finished with this line
  cmp #$77  ;'w'
  beq @JMP_WRITE
  cmp #$72  ;'r'
  beq @JMP_READ
  cmp #$61  ;'a'
  beq @JMP_SET_ADDRESS
  cmp #$6f  ;'o'
  beq @JMP_PRINT_ADDRESSES
  cmp #$62  ;'b'
  beq @JMP_BLOCK_EXAMINE
  cmp #$52  ;'R'
  beq @JMP_PRINT_REGISTERS
  cmp #$78  ;'x'
  beq @JMP_EXECUTE
  cmp #$6D  ;'m'
  beq @JMP_MINI_ASSEMBLER
  cmp #$6C  ;'l'
  beq @JMP_MINI_DISASSEMBLER
  cmp #$74  ;'t'
  beq @JMP_TRACEMON
  ldy #$01  ;No operand
  jsr PRINT_ERROR
  jmp ROM_MONITOR  ;Something bad happened

@JMP_WRITE:
  jmp @write

@JMP_READ:
  jmp @read

@JMP_SET_ADDRESS:
  jmp @set_address

@JMP_PRINT_ADDRESSES:
  jmp @print_addresses

@JMP_BLOCK_EXAMINE:
  jmp @block_examine

@JMP_PRINT_REGISTERS:
  jmp @print_registers

@JMP_EXECUTE:
  jmp @execute

@JMP_MINI_ASSEMBLER:
  jmp MINI_ASSEMBLER

@JMP_MINI_DISASSEMBLER:
  jmp MINI_DISASSEMBLER

@JMP_TRACEMON:
  jmp TRACEMON

;-------------------------------------------------------------;
; Write n amount of data from BUFFER to current STORE address ;
;-------------------------------------------------------------;

@write:
  iny

@write_loop:
  jsr SKIP_SPACES
  jsr PARSE_HEX
  lda HEX_L
  sta (STORE_L)

  lda BUFFER, y
  cmp #$0D  ;'CR'
  beq @write_done

  inc STORE_L
  bne @jmp_write_loop
  inc STORE_H

@jmp_write_loop:
  jmp @write_loop

@write_done:
  jmp @parse_character_loop

;--------------------------------------------------------;
; Examine a block of address from hex value to hex value ;
;--------------------------------------------------------;

@block_examine:
  iny
  jsr SKIP_SPACES
  jsr PARSE_HEX
  lda HEX_L
  sta EXAMINE_L
  lda HEX_H
  sta EXAMINE_H
  
  jsr SKIP_SPACES
  jsr PARSE_HEX
  lda HEX_L
  sta INDEX_L
  lda HEX_H
  sta INDEX_H
  jmp @begin_data_output

;------------------------------------------;
; Read n bytes from the address in examine ;
;------------------------------------------;

@read:
  lda #$00  ;clear index
  sta INDEX_L
  sta INDEX_H
  
  iny  ;current index is at 'r'
  jsr SKIP_SPACES
  jsr PARSE_HEX  ;get the hex value after r command

  lda EXAMINE_L
  adc HEX_L
  sta INDEX_L

  lda EXAMINE_H
  adc HEX_H
  sta INDEX_H

@begin_data_output:
  lda #$00

@print_new_line:
  bne @print_data
  lda #$0D  ;'CR'
  jsr CHAR_OUT
  lda EXAMINE_H
  jsr PRINT_BYTE
  lda EXAMINE_L
  jsr PRINT_BYTE
  lda #$3A  ;':'
  jsr CHAR_OUT

@print_data:
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda (EXAMINE_L)
  jsr PRINT_BYTE

  inc EXAMINE_L
  bne @no_read_count_wrap
  inc EXAMINE_H

@no_read_count_wrap:
  lda EXAMINE_H
  cmp INDEX_H
  bne @continue_reading

  lda EXAMINE_L
  cmp INDEX_L
  beq @done_reading

@continue_reading:
  lda EXAMINE_L
  and #$07
  jmp @print_new_line

@done_reading:
  jmp @parse_character_loop

;----------------------------------------------------;
; Set the current, store, examine address            ;
; Returns the new addsess in CURRENT, STORE, EXAMINE ;
; Registers affected: A, X, Y                        ;
;----------------------------------------------------;

@set_address:
  iny
  jsr SKIP_SPACES
  jsr PARSE_HEX

  lda HEX_L
  sta INDEX_L
  sta STORE_L
  sta EXAMINE_L

  lda HEX_H
  sta INDEX_H
  sta STORE_H
  sta EXAMINE_H

  lda #$0D  ;'CR'
  jsr CHAR_OUT

  lda HEX_H
  jsr PRINT_BYTE

  lda HEX_L
  jsr PRINT_BYTE

  lda #$3A  ;':'
  jsr CHAR_OUT

  lda #$20  ;'Space'
  jsr CHAR_OUT

  lda (EXAMINE_L)
  jsr PRINT_BYTE

  jmp @parse_character_loop

;-------------------------------------------------;
; Print the addresses out EXAMINE, STORE, CURRENT ;
;-------------------------------------------------;

@print_addresses:
  iny
  lda #$0D
  jsr CHAR_OUT

  ldx #$00
@print_examine_str:
  lda @examine_str,x
  beq @done_examine_print
  jsr CHAR_OUT
  inx
  jmp @print_examine_str

@done_examine_print:
  lda #$20
  jsr CHAR_OUT
  lda EXAMINE_H
  jsr PRINT_BYTE
  lda EXAMINE_L
  jsr PRINT_BYTE

  lda #$0D
  jsr CHAR_OUT

  ldx #$00
@print_index_str:
  lda @index_str,x
  beq @done_index_print
  jsr CHAR_OUT
  inx
  jmp @print_index_str

@done_index_print:
  lda #$20
  jsr CHAR_OUT
  lda INDEX_H
  jsr PRINT_BYTE
  lda INDEX_L
  jsr PRINT_BYTE

  lda #$0D
  jsr CHAR_OUT
  
  ldx #$00
@print_store_str:
  lda @store_str,x
  beq @done_store_print
  jsr CHAR_OUT
  inx
  jmp @print_store_str

@done_store_print:
  lda #$20
  jsr CHAR_OUT
  lda STORE_H
  jsr PRINT_BYTE
  lda STORE_L
  jsr PRINT_BYTE

  jmp @parse_character_loop

;-----------------------------;
; Print out all the registers ;
; Registers affected: A, X, Y ;
;-----------------------------;

@print_registers:
  iny
  lda #$0D
  jsr CHAR_OUT
  lda #$41  ;'A'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  pla  ;A should be last on stack from soft reset
  jsr PRINT_BYTE
  
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda #$58  ;'X'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  pla  ;X should be next
  jsr PRINT_BYTE
  
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda #$59  ;'Y'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  pla  ;Y should be next
  jsr PRINT_BYTE
  
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda #$53  ;'S'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  tsx
  txa
  jsr PRINT_BYTE
  
  lda #$20  ;'Space'
  jsr CHAR_OUT
  lda #$46  ;'F'
  jsr CHAR_OUT
  lda #$3A  ;':'
  jsr CHAR_OUT
  pla  ;Flags are last
  jsr PRINT_BYTE

  jmp @parse_character_loop

;Start executing code at this location

@execute:
  jmp (EXAMINE_L)

@examine_str: .asciiz "Examine:"
@store_str:   .asciiz "Store:"
@index_str:   .asciiz "Index:"


;---------------------------------------------------------------------;
; Parses hex value from input buffer until non hex (0-9,A-F) is found ;
; Returns the hex values found from input buffer in HEX_L, HEX_H      ;
; Registers affected: A, Y, X                                         ;
;---------------------------------------------------------------------;

PARSE_HEX:
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
  beq ROM_HARD_RESET  ;Hard reset before shit breaks
  rts

;-----------------------------------------------------------;
; Parse buffer for binary digits and stores them into HEX_L ;
; Registers affected: A, Y                                  ;
;-----------------------------------------------------------;

PARSE_BINARY:
  lda #$00
  sta HEX_L
  sta HEX_H
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
  beq ROM_HARD_RESET
  rts

ROM_HARD_RESET:
  jmp ROM_MONITOR

;----------------------------------------------;
; Skips spaces encountered in the input buffer ;
; Registers affected: A, Y                     ;
;----------------------------------------------;

SKIP_SPACES:
  lda BUFFER, y
  cmp #$20  ;space
  beq @do_skip  ;Skip over space
  rts
@do_skip:
  iny
  jmp SKIP_SPACES

;----------------------------------------------;
; Skips spaces encountered in the input buffer ;
; Registers affected: A, Y                     ;
;----------------------------------------------;

PRINT_ERROR:
  ldx #$00
@print_error_str:
  lda @error_str,x
  beq @done_error_print
  jsr CHAR_OUT
  inx
  jmp @print_error_str

@done_error_print:
  tya
  jsr PRINT_BYTE
  rts

@error_str:   .asciiz "syntax error: "

;------------------------------------------;
; Capitalize ASCII character in A register ;
; Registers affected: A                    ;
;------------------------------------------;

CAPITALIZE:
  cmp #'a'
  bmi @not_lowercase  ;Less than 'a' $61
  cmp #'z'+1
  bpl @not_lowercase  ;Greater than 'z' + 1 $7B
  and #%11011111  ;Clear the 5th bit
@not_lowercase:
  rts

