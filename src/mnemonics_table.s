
OP_ASL = $00  ;Accumulator
OP_ROL = $01
OP_LSR = $02
OP_ROR = $03
OP_DEC = $04
OP_INC = $05
OP_CLC = $06  ;Implied
OP_SEC = $07
OP_CLI = $08
OP_SEI = $09
OP_DEY = $0A
OP_TYA = $0B
OP_TAY = $0C
OP_CLV = $0D
OP_INY = $0E
OP_CLD = $0F
OP_INX = $10
OP_SED = $11
OP_TXA = $12
OP_TXS = $13
OP_TAX = $14
OP_TSX = $15
OP_DEX = $16
OP_WAI = $17
OP_STP = $18
OP_BPL = $19  ;Relative
OP_BMI = $1A
OP_BVC = $1B
OP_BVS = $1C
OP_BRA = $1D
OP_BCC = $1E
OP_BCS = $1F
OP_BNE = $20
OP_BEQ = $21
OP_BBR = $22
OP_BBS = $23
OP_BRK = $24  ;Stack
OP_RTI = $25
OP_RTS = $26
OP_PHP = $27
OP_PLP = $28
OP_PHA = $29
OP_PLA = $2A
OP_PHY = $2B
OP_PLY = $2C
OP_PHX = $2D
OP_PLX = $2E
OP_JSR = $2F
OP_LDY = $30
OP_CPY = $31
OP_CPX = $32
OP_ORA = $33
OP_AND = $34
OP_ADC = $35
OP_STA = $36
OP_LDA = $37
OP_CMP = $38
OP_SBC = $39
OP_TSB = $3A
OP_TRB = $3B
OP_BIT = $3C
OP_STZ = $3D
OP_STY = $3E
OP_STX = $3F
OP_RMB = $40
OP_SMB = $41
OP_NOP = $42
OP_JMP = $43
OP_EOR = $44
OP_LDX = $45
OP_LBL = $46
OP_UNK = $47

AM_ABSOLUTE                  = $00  ;JMP $5000
AM_ABSOLUTE_INDEXED_INDIRECT = $01  ;JMP ($2000, X)
AM_ABSOLUTE_INDEXED_X        = $02  ;STA $3000, X
AM_ABSOLUTE_INDEXED_Y        = $03  ;AND $4000, Y
AM_INDIRECT                  = $04  ;JMP ($FFFC)
AM_IMMEDIATE                 = $05  ;LDA #$10
AM_ACCUMULATOR               = $06  ;LSR A
AM_IMPLIED                   = $07  ;TAX
AM_STACK                     = $08  ;PHA
AM_RELATIVE                  = $09  ;BRA
AM_ZEROPAGE                  = $0A  ;LDA $00
AM_ZEROPAGE_INDEXED_INDIRECT = $0B  ;LDA ($40, X)
AM_ZEROPAGE_INDEXED_X        = $0C  ;LDA $40, X
AM_ZEROPAGE_INDEXED_Y        = $0D  ;LDA $40, Y
AM_ZEROPAGE_INDIRECT         = $0E  ;LDA ($20)
AM_ZEROPAGE_INDIRECT_INDEXED = $0F  ;LDA ($FC), Y
AM_UNKNOWN                   = $10

.code

MNEMONICS:
.byte "ASL"
.byte "ROL"
.byte "LSR"
.byte "ROR"
.byte "DEC"
.byte "INC"
.byte "CLC"
.byte "SEC"
.byte "CLI"
.byte "SEI"
.byte "DEY"
.byte "TYA"
.byte "TAY"
.byte "CLV"
.byte "INY"
.byte "CLD"
.byte "INX"
.byte "SED"
.byte "TXA"
.byte "TXS"
.byte "TAX"
.byte "TSX"
.byte "DEX"
.byte "WAI"
.byte "STP"
.byte "BPL"
.byte "BMI"
.byte "BVC"
.byte "BVS"
.byte "BRA"
.byte "BCC"
.byte "BCS"
.byte "BNE"
.byte "BEQ"
.byte "BBR"
.byte "BBS"
.byte "BRK"
.byte "RTI"
.byte "RTS"
.byte "PHP"
.byte "PLP"
.byte "PHA"
.byte "PLA"
.byte "PHY"
.byte "PLY"
.byte "PHX"
.byte "PLX"
.byte "JSR"
.byte "LDY"
.byte "CPY"
.byte "CPX"
.byte "ORA"
.byte "AND"
.byte "ADC"
.byte "STA"
.byte "LDA"
.byte "CMP"
.byte "SBC"
.byte "TSB"
.byte "TRB"
.byte "BIT"
.byte "STZ"
.byte "STY"
.byte "STX"
.byte "RMB"
.byte "SMB"
.byte "NOP"
.byte "JMP"
.byte "EOR"
.byte "LDX"
.byte "LBL"
.byte "UNK"  ;unknown
MNEMONICS_END:

OPCODES:
  .byte OP_BRK, AM_STACK                      ;00
  .byte OP_ORA, AM_ZEROPAGE_INDEXED_INDIRECT  ;01
  .byte OP_UNK, AM_UNKNOWN                    ;02
  .byte OP_UNK, AM_UNKNOWN                    ;03
  .byte OP_TSB, AM_ZEROPAGE                   ;04
  .byte OP_ORA, AM_ZEROPAGE                   ;05
  .byte OP_ASL, AM_ZEROPAGE                   ;06
  .byte OP_RMB, AM_ZEROPAGE                   ;07
  .byte OP_PHP, AM_STACK                      ;08
  .byte OP_ORA, AM_IMMEDIATE                  ;09
  .byte OP_ASL, AM_ACCUMULATOR                ;0A
  .byte OP_UNK, AM_UNKNOWN                    ;0B
  .byte OP_TSB, AM_ABSOLUTE                   ;0C
  .byte OP_ORA, AM_ABSOLUTE                   ;0D
  .byte OP_ASL, AM_ABSOLUTE                   ;0E
  .byte OP_BBR, AM_RELATIVE                   ;0F
  .byte OP_BPL, AM_RELATIVE                   ;10
  .byte OP_ORA, AM_ZEROPAGE_INDIRECT_INDEXED  ;11
  .byte OP_ORA, AM_ZEROPAGE_INDIRECT          ;12
  .byte OP_UNK, AM_UNKNOWN                    ;13
  .byte OP_TRB, AM_ZEROPAGE                   ;14
  .byte OP_ORA, AM_ZEROPAGE_INDEXED_X         ;15
  .byte OP_ASL, AM_ZEROPAGE_INDEXED_X         ;16
  .byte OP_RMB, AM_ZEROPAGE                   ;17
  .byte OP_CLC, AM_IMPLIED                    ;18
  .byte OP_ORA, AM_ABSOLUTE_INDEXED_Y         ;19
  .byte OP_INC, AM_ACCUMULATOR                ;1A
  .byte OP_UNK, AM_UNKNOWN                    ;1B
  .byte OP_TRB, AM_ABSOLUTE                   ;1C
  .byte OP_ORA, AM_ABSOLUTE_INDEXED_X         ;1D
  .byte OP_ASL, AM_ABSOLUTE_INDEXED_X         ;1E
  .byte OP_BBR, AM_RELATIVE                   ;1F
  .byte OP_JSR, AM_ABSOLUTE                   ;20
  .byte OP_AND, AM_ZEROPAGE_INDEXED_INDIRECT  ;21
  .byte OP_UNK, AM_UNKNOWN                    ;22
  .byte OP_UNK, AM_UNKNOWN                    ;23
  .byte OP_BIT, AM_ZEROPAGE                   ;24
  .byte OP_AND, AM_ZEROPAGE                   ;25
  .byte OP_ROL, AM_ZEROPAGE                   ;26
  .byte OP_RMB, AM_ZEROPAGE                   ;27
  .byte OP_PLP, AM_STACK                      ;28
  .byte OP_AND, AM_IMMEDIATE                  ;29
  .byte OP_ROL, AM_ACCUMULATOR                ;2A
  .byte OP_UNK, AM_UNKNOWN                    ;2B
  .byte OP_BIT, AM_ABSOLUTE                   ;2C
  .byte OP_AND, AM_ABSOLUTE                   ;2D
  .byte OP_ROL, AM_ABSOLUTE                   ;2E
  .byte OP_BBR, AM_RELATIVE                   ;2F
  .byte OP_BMI, AM_RELATIVE                   ;30
  .byte OP_AND, AM_ZEROPAGE_INDIRECT_INDEXED  ;31
  .byte OP_AND, AM_ZEROPAGE_INDIRECT          ;32
  .byte OP_UNK, AM_UNKNOWN                    ;33
  .byte OP_BIT, AM_ZEROPAGE_INDEXED_X         ;34
  .byte OP_AND, AM_ZEROPAGE_INDEXED_X         ;35
  .byte OP_ROL, AM_ZEROPAGE_INDEXED_X         ;36
  .byte OP_RMB, AM_ZEROPAGE                   ;37
  .byte OP_SEC, AM_IMPLIED                    ;38
  .byte OP_AND, AM_ABSOLUTE_INDEXED_Y         ;39
  .byte OP_DEC, AM_ACCUMULATOR                ;3A
  .byte OP_UNK, AM_UNKNOWN                    ;3B
  .byte OP_BIT, AM_ABSOLUTE_INDEXED_X         ;3C
  .byte OP_AND, AM_ABSOLUTE_INDEXED_X         ;3D
  .byte OP_ROL, AM_ABSOLUTE_INDEXED_X         ;3E
  .byte OP_BBR, AM_RELATIVE                   ;3F
  .byte OP_RTI, AM_STACK                      ;40
  .byte OP_EOR, AM_ZEROPAGE_INDEXED_INDIRECT  ;41
  .byte OP_UNK, AM_UNKNOWN                    ;42
  .byte OP_UNK, AM_UNKNOWN                    ;43
  .byte OP_UNK, AM_UNKNOWN                    ;44
  .byte OP_EOR, AM_ZEROPAGE                   ;45
  .byte OP_LSR, AM_ZEROPAGE                   ;46
  .byte OP_RMB, AM_ZEROPAGE                   ;47
  .byte OP_PHA, AM_STACK                      ;48
  .byte OP_EOR, AM_IMMEDIATE                  ;49
  .byte OP_LSR, AM_ACCUMULATOR                ;4A
  .byte OP_UNK, AM_UNKNOWN                    ;4B
  .byte OP_JMP, AM_ABSOLUTE                   ;4C
  .byte OP_EOR, AM_ABSOLUTE                   ;4D
  .byte OP_LSR, AM_ABSOLUTE                   ;4E
  .byte OP_BBR, AM_RELATIVE                   ;4F
  .byte OP_BVC, AM_RELATIVE                   ;50
  .byte OP_EOR, AM_ZEROPAGE_INDIRECT_INDEXED  ;51
  .byte OP_EOR, AM_ZEROPAGE                   ;52
  .byte OP_UNK, AM_UNKNOWN                    ;53
  .byte OP_UNK, AM_UNKNOWN                    ;54
  .byte OP_EOR, AM_ZEROPAGE_INDEXED_X         ;55
  .byte OP_LSR, AM_ZEROPAGE_INDEXED_X         ;56
  .byte OP_RMB, AM_ZEROPAGE                   ;57
  .byte OP_CLI, AM_IMPLIED                    ;58
  .byte OP_EOR, AM_ABSOLUTE_INDEXED_Y         ;59
  .byte OP_PHY, AM_STACK                      ;5A
  .byte OP_UNK, AM_UNKNOWN                    ;5B
  .byte OP_UNK, AM_UNKNOWN                    ;5C
  .byte OP_EOR, AM_ABSOLUTE_INDEXED_X         ;5D
  .byte OP_LSR, AM_ABSOLUTE_INDEXED_X         ;5E
  .byte OP_BBR, AM_RELATIVE                   ;5F
  .byte OP_RTS, AM_STACK                      ;60
  .byte OP_ADC, AM_ZEROPAGE_INDEXED_INDIRECT  ;61
  .byte OP_UNK, AM_UNKNOWN                    ;62
  .byte OP_UNK, AM_UNKNOWN                    ;63
  .byte OP_STZ, AM_ZEROPAGE                   ;64
  .byte OP_ADC, AM_ZEROPAGE                   ;65
  .byte OP_ROR, AM_ZEROPAGE                   ;66
  .byte OP_RMB, AM_ZEROPAGE                   ;67
  .byte OP_PLA, AM_STACK                      ;68
  .byte OP_ADC, AM_IMMEDIATE                  ;69
  .byte OP_ROR, AM_ACCUMULATOR                ;6A
  .byte OP_UNK, AM_UNKNOWN                    ;6B
  .byte OP_JMP, AM_INDIRECT                   ;6C
  .byte OP_ADC, AM_ABSOLUTE                   ;6D
  .byte OP_ROR, AM_ABSOLUTE                   ;6E
  .byte OP_BBR, AM_RELATIVE                   ;6F
  .byte OP_BVS, AM_RELATIVE                   ;70
  .byte OP_ADC, AM_ZEROPAGE_INDIRECT_INDEXED  ;71
  .byte OP_ADC, AM_ZEROPAGE                   ;72
  .byte OP_UNK, AM_UNKNOWN                    ;73
  .byte OP_STZ, AM_ZEROPAGE_INDEXED_X         ;74
  .byte OP_ADC, AM_ZEROPAGE_INDEXED_X         ;75
  .byte OP_ROR, AM_ZEROPAGE_INDEXED_X         ;76
  .byte OP_RMB, AM_ZEROPAGE                   ;77
  .byte OP_SEI, AM_IMPLIED                    ;78
  .byte OP_ADC, AM_ABSOLUTE_INDEXED_Y         ;79
  .byte OP_PLY, AM_STACK                      ;7A
  .byte OP_UNK, AM_UNKNOWN                    ;7B
  .byte OP_JMP, AM_ABSOLUTE_INDEXED_INDIRECT  ;7C
  .byte OP_ADC, AM_ABSOLUTE_INDEXED_X         ;7D
  .byte OP_ROR, AM_ABSOLUTE_INDEXED_X         ;7E
  .byte OP_BBR, AM_RELATIVE                   ;7F
  .byte OP_BRA, AM_RELATIVE                   ;80
  .byte OP_STA, AM_ZEROPAGE_INDEXED_INDIRECT  ;81
  .byte OP_UNK, AM_UNKNOWN                    ;82
  .byte OP_UNK, AM_UNKNOWN                    ;83
  .byte OP_STY, AM_ZEROPAGE                   ;84
  .byte OP_STA, AM_ZEROPAGE                   ;85
  .byte OP_STX, AM_ZEROPAGE                   ;86
  .byte OP_SMB, AM_ZEROPAGE                   ;87
  .byte OP_DEY, AM_IMPLIED                    ;88
  .byte OP_BIT, AM_IMMEDIATE                  ;89
  .byte OP_TXA, AM_IMPLIED                    ;8A
  .byte OP_UNK, AM_UNKNOWN                    ;8B
  .byte OP_STY, AM_ABSOLUTE                   ;8C
  .byte OP_STA, AM_ABSOLUTE                   ;8D
  .byte OP_STX, AM_ABSOLUTE                   ;8E
  .byte OP_BBS, AM_RELATIVE                   ;8F
  .byte OP_BCC, AM_RELATIVE                   ;90
  .byte OP_STA, AM_ZEROPAGE_INDIRECT_INDEXED  ;91
  .byte OP_STA, AM_ZEROPAGE_INDIRECT          ;92
  .byte OP_UNK, AM_UNKNOWN                    ;93
  .byte OP_STY, AM_ZEROPAGE_INDEXED_X         ;94
  .byte OP_STA, AM_ZEROPAGE_INDEXED_X         ;95
  .byte OP_STX, AM_ZEROPAGE_INDEXED_Y         ;96
  .byte OP_SMB, AM_ZEROPAGE                   ;97
  .byte OP_TYA, AM_IMPLIED                    ;98
  .byte OP_STA, AM_ABSOLUTE_INDEXED_Y         ;99
  .byte OP_TXS, AM_IMPLIED                    ;9A
  .byte OP_UNK, AM_UNKNOWN                    ;9B
  .byte OP_STZ, AM_ABSOLUTE                   ;9C
  .byte OP_STA, AM_ABSOLUTE_INDEXED_X         ;9D
  .byte OP_STZ, AM_ABSOLUTE_INDEXED_X         ;9E
  .byte OP_BBS, AM_RELATIVE                   ;9F
  .byte OP_LDY, AM_IMMEDIATE                  ;A0
  .byte OP_LDA, AM_ZEROPAGE_INDEXED_INDIRECT  ;A1
  .byte OP_LDX, AM_IMMEDIATE                  ;A2
  .byte OP_UNK, AM_UNKNOWN                    ;A3
  .byte OP_LDY, AM_ZEROPAGE                   ;A4
  .byte OP_LDA, AM_ZEROPAGE                   ;A5
  .byte OP_LDX, AM_ZEROPAGE                   ;A6
  .byte OP_SMB, AM_ZEROPAGE                   ;A7
  .byte OP_TAY, AM_IMPLIED                    ;A8
  .byte OP_LDA, AM_IMMEDIATE                  ;A9
  .byte OP_TAX, AM_IMPLIED                    ;AA
  .byte OP_UNK, AM_UNKNOWN                    ;AB
  .byte OP_LDY, AM_ABSOLUTE                   ;AC
  .byte OP_LDA, AM_ABSOLUTE                   ;AD
  .byte OP_LDX, AM_ABSOLUTE                   ;AE
  .byte OP_BBS, AM_RELATIVE                   ;AF
  .byte OP_BCS, AM_RELATIVE                   ;B0
  .byte OP_LDA, AM_ZEROPAGE_INDIRECT_INDEXED  ;B1
  .byte OP_LDA, AM_ZEROPAGE_INDIRECT          ;B2
  .byte OP_UNK, AM_UNKNOWN                    ;B3
  .byte OP_LDY, AM_ZEROPAGE_INDEXED_X         ;B4
  .byte OP_LDA, AM_ZEROPAGE_INDEXED_X         ;B5
  .byte OP_LDX, AM_ZEROPAGE_INDEXED_Y         ;B6
  .byte OP_SMB, AM_ZEROPAGE                   ;B7
  .byte OP_CLV, AM_IMPLIED                    ;B8
  .byte OP_LDA, AM_ABSOLUTE_INDEXED_Y         ;B9
  .byte OP_TSX, AM_IMPLIED                    ;BA
  .byte OP_UNK, AM_UNKNOWN                    ;BB
  .byte OP_LDY, AM_ABSOLUTE_INDEXED_X         ;BC
  .byte OP_LDA, AM_ABSOLUTE_INDEXED_X         ;BD
  .byte OP_LDX, AM_ABSOLUTE_INDEXED_Y         ;BE
  .byte OP_BBS, AM_RELATIVE                   ;BF
  .byte OP_CPY, AM_IMMEDIATE                  ;C0
  .byte OP_CMP, AM_ZEROPAGE_INDEXED_INDIRECT  ;C1
  .byte OP_UNK, AM_UNKNOWN                    ;C2
  .byte OP_UNK, AM_UNKNOWN                    ;C3
  .byte OP_CPY, AM_ZEROPAGE                   ;C4
  .byte OP_CMP, AM_ZEROPAGE                   ;C5
  .byte OP_DEC, AM_ZEROPAGE                   ;C6
  .byte OP_SMB, AM_ZEROPAGE                   ;C7
  .byte OP_INY, AM_IMPLIED                    ;C8
  .byte OP_CMP, AM_IMMEDIATE                  ;C9
  .byte OP_DEX, AM_IMPLIED                    ;CA
  .byte OP_WAI, AM_IMPLIED                    ;CB
  .byte OP_CPY, AM_ABSOLUTE                   ;CC
  .byte OP_CMP, AM_ABSOLUTE                   ;CD
  .byte OP_DEC, AM_ABSOLUTE                   ;CE
  .byte OP_BBS, AM_RELATIVE                   ;CF
  .byte OP_BNE, AM_RELATIVE                   ;D0
  .byte OP_CMP, AM_ZEROPAGE_INDIRECT_INDEXED  ;D1
  .byte OP_CMP, AM_ZEROPAGE_INDIRECT          ;D2
  .byte OP_UNK, AM_UNKNOWN                    ;D3
  .byte OP_UNK, AM_UNKNOWN                    ;D4
  .byte OP_CMP, AM_ZEROPAGE_INDEXED_X         ;D5
  .byte OP_DEC, AM_ZEROPAGE_INDEXED_X         ;D6
  .byte OP_SMB, AM_ZEROPAGE                   ;D7
  .byte OP_CLD, AM_IMPLIED                    ;D8
  .byte OP_CMP, AM_ABSOLUTE_INDEXED_Y         ;D9
  .byte OP_PHX, AM_STACK                      ;DA
  .byte OP_STP, AM_IMPLIED                    ;DB
  .byte OP_UNK, AM_UNKNOWN                    ;DC
  .byte OP_CMP, AM_ABSOLUTE_INDEXED_X         ;DD
  .byte OP_DEC, AM_ABSOLUTE_INDEXED_X         ;DE
  .byte OP_BBS, AM_RELATIVE                   ;DF
  .byte OP_CPX, AM_IMMEDIATE                  ;E0
  .byte OP_SBC, AM_ZEROPAGE_INDEXED_INDIRECT  ;E1
  .byte OP_UNK, AM_UNKNOWN                    ;E2
  .byte OP_UNK, AM_UNKNOWN                    ;E3
  .byte OP_CPX, AM_ZEROPAGE                   ;E4
  .byte OP_SBC, AM_ZEROPAGE                   ;E5
  .byte OP_INC, AM_ZEROPAGE                   ;E6
  .byte OP_SMB, AM_ZEROPAGE                   ;E7
  .byte OP_INX, AM_IMPLIED                    ;E8
  .byte OP_SBC, AM_IMMEDIATE                  ;E9
  .byte OP_NOP, AM_IMPLIED                    ;EA
  .byte OP_UNK, AM_UNKNOWN                    ;EB
  .byte OP_CPX, AM_ABSOLUTE                   ;EC
  .byte OP_SBC, AM_ABSOLUTE                   ;ED
  .byte OP_INC, AM_ABSOLUTE                   ;EE
  .byte OP_BBS, AM_RELATIVE                   ;EF
  .byte OP_BEQ, AM_RELATIVE                   ;F0
  .byte OP_SBC, AM_ZEROPAGE_INDIRECT_INDEXED  ;F1
  .byte OP_SBC, AM_ZEROPAGE_INDIRECT          ;F2
  .byte OP_UNK, AM_UNKNOWN                    ;F3
  .byte OP_UNK, AM_UNKNOWN                    ;F4
  .byte OP_SBC, AM_ZEROPAGE_INDEXED_X         ;F5
  .byte OP_INC, AM_ZEROPAGE_INDEXED_X         ;F6
  .byte OP_SMB, AM_ZEROPAGE                   ;F7
  .byte OP_SED, AM_IMPLIED                    ;F8
  .byte OP_SBC, AM_ABSOLUTE_INDEXED_Y         ;F9
  .byte OP_PLX, AM_STACK                      ;FA
  .byte OP_UNK, AM_UNKNOWN                    ;FB
  .byte OP_UNK, AM_UNKNOWN                    ;FC
  .byte OP_SBC, AM_ABSOLUTE_INDEXED_X         ;FD
  .byte OP_INC, AM_ABSOLUTE_INDEXED_X         ;FE
  .byte OP_BBS, AM_RELATIVE                   ;FF
OPCODES_END:

