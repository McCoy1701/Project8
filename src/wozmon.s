
IN = $0200

.segment "WOZMON"

WOZMON:
  lda #$1f
  sta ACIA_CONTROL
  lda #$0b
  sta ACIA_COMMAND
  lda #$1b

NOT_CR:
  cmp #$08             ;Backspace key
  beq BACKSPACE
  cmp #$1b             ;Escape key
  beq ESCAPE
  iny
  bpl NEXT_CHAR

ESCAPE:
  lda #$5c             ;'\'
  jsr ECHO

GETLINE:
  lda #$0d             ;Send CR
  jsr ECHO
  
  ldy #$01             ;Initialize text index
BACKSPACE:
  dey                  ;Back up text index
  bmi GETLINE          ;Beyond start of line, reinitialize

NEXT_CHAR:
  lda ACIA_STATUS          ;Check acia for data
  and #$08
  beq NEXT_CHAR
  lda ACIA_DATA
  sta IN, y            ;Store key in text buffer
  jsr ECHO             ;Output character
  cmp #$0d             ;CR?
  bne NOT_CR           ;No
  
  ldy #$ff
  lda #$00
  tax

SET_BLOCK:
  asl

SET_STORE:
  asl
  sta MODE

BLANK_SKIP:
  iny

NEXT_ITEM:
  lda IN, y
  cmp #$0d
  beq GETLINE
  cmp #$2e
  bcc BLANK_SKIP
  beq SET_BLOCK
  cmp #$3a
  beq SET_STORE
  cmp #$52
  beq RUN
  stx L
  stx H
  sty YSAV

NEXT_HEX:
  lda IN, y
  eor #$30
  cmp #$0a
  bcc DIGIT
  adc #$88
  cmp #$fa
  bcc NOT_HEX

DIGIT:
  asl
  asl
  asl
  asl

  ldx #$04
HEX_SHIFT:
  asl
  rol L
  rol H
  dex
  bne HEX_SHIFT
  iny
  bne NEXT_HEX

NOT_HEX:
  cpy YSAV
  beq ESCAPE

  bit MODE
  bvc NOT_STORE

  lda L
  sta (STL, x)
  inc STL
  bne NEXT_ITEM
  inc STH

TO_NEXT_ITEM:
  jmp NEXT_ITEM

RUN:
  jmp (XAML)

NOT_STORE:
  bmi XAM_NEXT

  ldx #$02
SET_ADDR:
  lda L-1, x
  sta STL-1, x
  sta XAML-1, x
  dex
  bne SET_ADDR

NEXT_PRINT:
  bne PRINT_DATA
  lda #$0d
  jsr ECHO
  lda XAMH
  jsr PRINT_BYTE
  lda XAML
  jsr PRINT_BYTE
  lda #$3a             ;':'
  jsr ECHO

PRINT_DATA:
  lda #$20
  jsr ECHO
  lda (XAML, x)
  jsr PRINT_BYTE

XAM_NEXT:
  stx MODE
  lda XAML
  cmp L
  lda XAMH
  sbc H
  bcs TO_NEXT_ITEM

  inc XAML
  BNE MOD_8_CHECK
  inc XAMH

MOD_8_CHECK:
  lda XAML
  and #$07
  bpl NEXT_PRINT

PRINT_BYTE:
  pha
  lsr
  lsr
  lsr
  lsr
  jsr PRINT_HEX
  pla

PRINT_HEX:
  and #$0f
  ora #$30
  cmp #$3a
  bcc ECHO
  adc #$06

ECHO:
  pha
  sta ACIA_DATA
  lda #$ff
@txdelay:
  dec
  bne @txdelay
  pla
  rts

