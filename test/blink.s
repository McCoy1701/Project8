PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003

  .org $8000

reset:
  ldx #$ff ;initialize the stack pointer to 1ff
  txs

  lda #$ff ;Make port b all outputs
  sta DDRB

  lda #$50
  sta PORTB

loop:
  jsr rotate_right
  jmp loop

rotate_right:
  ror ;Rotate the contents of a right
  sta PORTB
  rts

  .org $fffc
  .word reset
  .word $0000
