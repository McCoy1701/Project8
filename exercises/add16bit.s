ADDR1 = $0000
ADDR2 = $0002
ADDR3 = $0004
ADDR1 = $0008
ADDR2 = $000a
ADDR3 = $000c

  .org $8000                  ;Where program execution starts

reset:
  clc                         ;Clear the carry flag
  cld                         ;Clear the demical flag

;----------------------------------------------------------------------
;   Exercises 3.2: Rewrite the 16-bit addition program above with the
; memory layout indicated in Figure 3-6A.
;----------------------------------------------------------------------

  lda #$05                    ;Load accumlator with low half of 0505
  sta ADDR1                   ;Store accumlator to ADDR1
  lda #$05                    ;Load accumlator with high half of 0505
  sta ADDR1 + 1               ;Store accumlator to ADDR1 + 1

  lda #$06                    ;Load accumlator with low half of 0606
  sta ADDR2                   ;Store accumlator to ADDR2
  lda #$06                    ;Load accumlator with high half of 0606
  sta ADDR2 + 1               ;Store accumlator to ADDR2 + 1

  lda ADDR1                   ;Load low half into accumlator
  adc ADDR2                   ;Add with carry ADDR1 low half + ADDR2 low half
  sta ADDR3                   ;Store the result in ADDR3
  
  lda ADDR1 + 1               ;Load high half into accumlator
  adc ADDR2 + 1               ;Add with carry ADDR1 high half + ADDR2 high half
  sta ADDR3 + 1               ;Store the result in ADDR3 + 1

;----------------------------------------------------------------------
;   Exercises 3.3: Assume now that ADDR1 does not point to the lower
; half of OPR1, but points to the higher part of OPR1. This is
; illustrated in Figure 3-6B.
;----------------------------------------------------------------------

  lda #$07                    ;Load accumlator with high half of 0707
  sta ADDR1                   ;Store accumlator to ADDR1
  lda #$07                    ;Load accumlator with low half of 0707
  sta ADDR1 - 1               ;Store accumlator to ADDR1 - 1

  lda #$08                    ;Load accumlator with high half of 0707
  sta ADDR2                   ;Store accumlator to ADDR2
  lda #$08                    ;Load accumlator with low half of 0707
  sta ADDR2 - 1               ;Store accumlator to ADDR2 - 1

  lda ADDR1 - 1               ;Load low half into accumlator
  adc ADDR2 - 1               ;Add with carry ADDR1 low half + ADDR2 low half
  sta ADDR3 - 1               ;Store the result in ADDR3 - 1
  
  lda ADDR1                   ;Load high half into accumlator
  adc ADDR2                   ;Add with carry ADDR1 high half + ADDR2 high half
  sta ADDR3                   ;Store the result in ADDR3
  .org  $fffa                 ;Setting the vectors
  .word $0000                 ;Non-Maskable Interrupt
  .word reset                 ;Reset Vector
  .word $0000                 ;Interrupt Request

