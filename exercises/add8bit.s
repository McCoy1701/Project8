ADDR1 = $0000
ADDR2 = $0001
ADDR3 = $0002

  .org $8000 ;Where program execution starts

reset:
  clc ;Clear the carry flag
  cld ;Clear the demical flag

  lda #$05 ;load accumlator with hex 5 
  sta ADDR1 ;store accumlator to ADDR1

  lda #$06 ;load accumlator with hex 6
  sta ADDR2 ;store accumlator to ADDR2

  lda ADDR1 ;load ADDR1 to accumlator
  adc ADDR2 ;add with carry ADDR1 + ADDR2
  sta ADDR3 ;store the result in ADDR3

  .org  $fffa ; Setting the vectors
  .word $0000 ; Non-Maskable Interrupt
  .word reset ; Reset Vector
  .word $0000 ; Interrupt Request

