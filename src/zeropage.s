
;Mini Assembler Pointers
OP_INDEX     = $E0
OPCODE       = $E1
ADDRESS_MODE = $E2
MNEMONIC     = $E3  ;3bytes
OPERAND      = $E6  ;2bytes

;Rom Monitor Pointers
BUFFER_INDEX = $E8
HEX_L        = $E9
HEX_H        = $EA
INDEX_L      = $EB
INDEX_H      = $EC
STORE_L      = $ED
STORE_H      = $EE
EXAMINE_L    = $EF
EXAMINE_H    = $F0

;System Pointers
READ_PTR     = $F6
WRITE_PTR    = $F7
IRQ_SAVE_A   = $F8
SPI_MOSI     = $F9
SPI_MISO     = $FA
TOGGLE_TIME  = $FB
TICKS        = $FC  ;4bytes

