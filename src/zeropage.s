.ZEROPAGE

.org $00E0

;Mini Assembler Pointers
OP_INDEX:     .res 1 
OPCODE:       .res 1
ADDRESS_MODE: .res 1
MNEMONIC:     .res 3
OPERAND:      .res 2

;Rom Monitor Pointers
BUFFER_INDEX: .res 1
HEX_L:        .res 1
HEX_H:        .res 1
INDEX_L:      .res 1
INDEX_H:      .res 1
STORE_L:      .res 1
STORE_H:      .res 1
EXAMINE_L:    .res 1
EXAMINE_H:    .res 1

;System Pointers
IRQ_SAVE_A:   .res 1
WRITE_PTR:    .res 1
READ_PTR:     .res 1
SPI_MOSI:     .res 1
SPI_MISO:     .res 1
TOGGLE_TIME:  .res 1
TICKS:        .res 4

.reloc

