
;Tracemon Pointers
BREAKPOINT_COUNTER = $CA
RETURN_ADDRESS     = $CB  ;2bytes
JUMP_ADDRESS       = $CD  ;2bytes

;Disassembler Pointers
FF_COUNTER         = $CF

;RAM Test Pointers
RAM_TEST           = $D0
START_INDEX        = $D1  ;2bytes
WRITE_INDEX        = $D3  ;2bytes
TEST_PATTERN       = $D5

;Helper Pointers
SEED               = $D6  ;2bytes
TEMP_WORD0         = $D8  ;2bytes
TEMP_WORD1         = $DA  ;2bytes
TEMP_WORD2         = $DC  ;2bytes
TEMP_WORD3         = $DE  ;2bytes

;Mini Assembler Pointers
OP_INDEX           = $E0
ADDRESS_MODE       = $E1
MNEMONIC           = $E2  ;3bytes
OPCODE             = $E5
OPERAND            = $E6  ;2bytes

;Rom Monitor Pointers
BUFFER_INDEX       = $E8
HEX_L              = $E9
HEX_H              = $EA
INDEX_L            = $EB
INDEX_H            = $EC
STORE_L            = $ED
STORE_H            = $EE
EXAMINE_L          = $EF
EXAMINE_H          = $F0

;System Pointers
READ_PTR           = $F5
WRITE_PTR          = $F6
IRQ_SAVE_A         = $F7
SPI_MOSI           = $F8
SPI_MISO           = $F9
DELAY_TICKS        = $FA
DELTA_TICKS        = $FB
TICKS              = $FC  ;4bytes

