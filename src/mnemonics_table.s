
OP_BRK = $00
OP_BPL = $01
OP_JSR = $02
OP_BMI = $03
OP_RTI = $04
OP_BVC = $05
OP_RTS = $06
OP_BVS = $07
OP_BRA = $08
OP_BCC = $09
OP_LDY = $0A
OP_BCS = $0B
OP_CPY = $0C
OP_BNE = $0D
OP_CPX = $0E
OP_BEQ = $0F
OP_ORA = $10
OP_AND = $11
OP_ADC = $12
OP_STA = $13
OP_LDA = $14
OP_CMP = $15
OP_SBC = $16
OP_TSB = $17
OP_TRB = $18
OP_BIT = $19
OP_STZ = $1A
OP_STY = $1B
OP_ASL = $1C
OP_ROL = $1D
OP_LSR = $1E
OP_ROR = $1F
OP_STX = $20
OP_DEC = $21
OP_INC = $22
OP_RMB = $23
OP_SMB = $24
OP_PHP = $25
OP_CLC = $26
OP_PLP = $27
OP_SEC = $28
OP_PHA = $29
OP_CLI = $2A
OP_PLA = $2B
OP_SEI = $2C
OP_DEY = $2D
OP_TYA = $2E
OP_TAY = $2F
OP_CLV = $30
OP_INY = $31
OP_CLD = $32
OP_INX = $33
OP_SED = $34
OP_PHY = $35
OP_PLY = $36
OP_TXA = $37
OP_TXS = $38
OP_TAX = $39
OP_TSX = $3A
OP_DEX = $3B
OP_PHX = $3C
OP_NOP = $3D
OP_PLX = $3E
OP_WAI = $3F
OP_STP = $40
OP_JMP = $41
OP_BBR = $42
OP_BBS = $43
OP_EOR = $44
OP_LDX = $45
OP_UNK = $46

AM_ABSOLUTE                  = $00
AM_ABSOLUTE_INDEXED_INDIRECT = $01
AM_ABSOLUTE_INDEXED_X        = $02
AM_ABSOLUTE_INDEXED_Y        = $03
AM_ABSOLUTE_INDIRECT         = $04
AM_ACCUMULATOR               = $05
AM_IMMEDIATE                 = $06
AM_IMPLIED                   = $07
AM_RELATIVE                  = $08
AM_STACK                     = $09
AM_ZEROPAGE                  = $0A
AM_ZEROPAGE_INDEXED_INDIRECT = $0B
AM_ZEROPAGE_INDEXED_X        = $0C
AM_ZEROPAGE_INDEXED_Y        = $0D
AM_ZEROPAGE_INDIRECT         = $0E
AM_ZEROPAGE_INDIRECT_INDEXED = $0F
AM_UNKNOWN                   = $10

.code

MNEMONICS:
.byte "BRK"
.byte "BPL"
.byte "JSR"
.byte "BMI"
.byte "RTI"
.byte "BVC"
.byte "RTS"
.byte "BVS"
.byte "BRA"
.byte "BCC"
.byte "LDY"
.byte "BCS"
.byte "CPY"
.byte "BNE"
.byte "CPX"
.byte "BEQ"
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
.byte "ASL"
.byte "ROL"
.byte "LSR"
.byte "ROR"
.byte "STX"
.byte "DEC"
.byte "INC"
.byte "RMB"
.byte "SMB"
.byte "PHP"
.byte "CLC"
.byte "PLP"
.byte "SEC"
.byte "PHA"
.byte "CLI"
.byte "PLA"
.byte "SEI"
.byte "DEY"
.byte "TYA"
.byte "TAY"
.byte "CLV"
.byte "INY"
.byte "CLD"
.byte "INX"
.byte "SED"
.byte "PHY"
.byte "PLY"
.byte "TXA"
.byte "TXS"
.byte "TAX"
.byte "TSX"
.byte "DEX"
.byte "PHX"
.byte "NOP"
.byte "PLX"
.byte "WAI"
.byte "STP"
.byte "JMP"
.byte "BBR"
.byte "BBS"
.byte "???"  ;unknown
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
  .byte OP_TRB, AM_ZEROPAGE_INDIRECT          ;14
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
  .byte OP_JMP, AM_ABSOLUTE_INDIRECT          ;6C
  .byte OP_ADC, AM_ABSOLUTE                   ;6D
  .byte OP_ROR, AM_ABSOLUTE                   ;6E
  .byte OP_BBR, AM_ABSOLUTE                   ;6F
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
  .byte OP_LDA, AM_ZEROPAGE                   ;B2
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
  .byte OP_SBC, AM_ZEROPAGE                   ;F2
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

