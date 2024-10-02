
OP_UNK = $00
OP_BRK = $01
OP_BPL = $02
OP_JSR = $03
OP_BMI = $04
OP_RTI = $05
OP_BVC = $06
OP_RTS = $07
OP_BVS = $08
OP_BRA = $09
OP_BCC = $0A
OP_LDY = $0B
OP_BCS = $0C
OP_CPY = $0D
OP_BNE = $0E
OP_CPX = $0F
OP_BEQ = $10
OP_ORA = $11
OP_AND = $12
OP_ADC = $13
OP_STA = $14
OP_LDA = $15
OP_CMP = $16
OP_SBC = $17
OP_TSB = $18
OP_TRB = $19
OP_BIT = $1A
OP_STZ = $1B
OP_STY = $1C
OP_ASL = $1D
OP_ROL = $1E
OP_LSR = $1F
OP_ROR = $20
OP_STX = $21
OP_DEC = $22
OP_INC = $23
OP_RMB = $24
OP_SMB = $25
OP_PHP = $26
OP_CLC = $27
OP_PLP = $28
OP_SEC = $29
OP_PHA = $2A
OP_CLI = $2B
OP_PLA = $2C
OP_SEI = $2D
OP_DEY = $2E
OP_TYA = $2F
OP_TAY = $30
OP_CLV = $31
OP_INY = $32
OP_CLD = $33
OP_INX = $34
OP_SED = $35
OP_PHY = $36
OP_PLY = $37
OP_TXA = $38
OP_TXS = $39
OP_TAX = $3A
OP_TSX = $3B
OP_DEX = $3C
OP_PHX = $3D
OP_NOP = $3E
OP_PLX = $3F
OP_WAI = $40
OP_STP = $41
OP_JMP = $42
OP_BBR = $43
OP_BBS = $44

AM_UNKNOWN                   = $00
AM_ABSOLUTE                  = $01
AM_ABSOLUTE_INDEXED_INDIRECT = $02
AM_ABSOLUTE_INDEXED_X        = $03
AM_ABSOLUTE_INDEXED_Y        = $04
AM_ABSOLUTE_INDIRECT         = $05
AM_ACCUMULATOR               = $06
AM_IMMEDIATE                 = $07
AM_IMPLIED                   = $08
AM_RELATIVE                  = $09
AM_STACK                     = $0A
AM_ZEROPAGE                  = $0B
AM_ZEROPAGE_INDEXED_INDIRECT = $0C
AM_ZEROPAGE_INDEXED_X        = $0D
AM_ZEROPAGE_INDEXED_Y        = $0E
AM_ZEROPAGE_INDIRECT         = $0F
AM_ZEROPAGE_INDIRECT_INDEXED = $10

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

OPCODES:
