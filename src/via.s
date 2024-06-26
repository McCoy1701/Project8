;AUXILIARY CONTROL REGISTER
ACR_T1_SINGLE_SHOT_NO_PB7             = %00000000
ACR_T1_CONTINUOUS_NO_PB7              = %01000000
ACR_T1_SINGLE_SHOT_PB7_ONE_SHOT       = %10000000
ACR_T1_CONTINUOUS_PB7_SQUARE_WAVE     = %11000000
ACR_T2_TIMED                          = %00000000
ACR_T2_COUNT_DOWN                     = %00100000
ACR_SR_DISABLED                       = %00000000
ACR_SR_SHIFT_IN_T2                    = %00000100
ACR_SR_SHIFT_IN_PHI2                  = %00001000
ACR_SR_SHIFT_IN_EXT_CLK               = %00001100
ACR_SR_SHIFT_OUT_FREE_T2              = %00010000
ACR_SR_SHIFT_OUT_T2                   = %00010100
ACR_SR_SHIFT_OUT_PHI2                 = %00011000
ACR_SR_SHIFT_OUT_EXT_CLK              = %00011100
ACR_LATCH_PB_DISABLE                  = %00000000
ACR_LATCH_PB_ENABLE                   = %00000010
ACR_LATCH_PA_DISABLE                  = %00000000
ACR_LATCH_PA_ENABLE                   = %00000001

;PERIPHERAL CONTROL REGISTER
PCR_CB2_INPUT_NEGATIVE_EDGE           = %00000000
PCR_CB2_INTERRUPT_INPUT_NEGATIVE_EDGE = %00100000
PCR_CB2_INPUT_POSITIVE_EDGE           = %01000000
PCR_CB2_INTERRUPT_INPUT_POSITIVE_EDGE = %01100000
PCR_CB2_HANDSHAKE_OUTPUT              = %10000000
PCR_CB2_PULSE_OUTPUT                  = %10100000
PCR_CB2_LOW_OUTPUT                    = %11000000
PCR_CB2_HIGH_OUTPUT                   = %11100000
PCR_CB1_NEGATIVE_EDGE                 = %00000000
PCR_CB1_POSITIVE_EDGE                 = %00010000
PCR_CA2_INPUT_NEGATIVE_EDGE           = %00000000
PCR_CA2_INTERRUPT_INPUT_NEGATIVE_EDGE = %00000010
PCR_CA2_INPUT_POSITIVE_EDGE           = %00000100
PCR_CA2_INTERRUPT_INPUT_POSITIVE_EDGE = %00000110
PCR_CA2_HANDSHAKE_OUTPUT              = %00001000
PCR_CA2_PULSE_OUTPUT                  = %00001010
PCR_CA2_LOW_OUTPUT                    = %00001100
PCR_CA2_HIGH_OUTPUT                   = %00001110
PCR_CA1_NEGATIVE_EDGE                 = %00000000
PCR_CA1_POSITIVE_EDGE                 = %00000001

;INTERRUPT FLAGS REGISTER
IFR_CA2_ACTIVE_EDGE                   = %00000001
IFR_CA1_ACTIVE_EDGE                   = %00000010
IFR_COMPLETE_8_SHIFTS                 = %00000100
IFR_CB2_ACTIVE_EDGE                   = %00001000
IFR_CB1_ACTIVE_EDGE                   = %00010000
IFR_TIME_OUT_T2                       = %00100000
IFR_TIME_OUT_T1                       = %01000000
IFR_INTERRUPT                         = %10000000

;INTERRUPT ENABLE REGISTER
IER_CLEAR_INTERRUPTS                  = %00000000
IER_SET_INTERRUPTS                    = %10000000
IER_TIMER1                            = %01000000
IER_TIMER2                            = %00100000
IER_CB1                               = %00010000
IER_CB2                               = %00001000
IER_SHIFT                             = %00000100
IER_CA1                               = %00000010
IER_CA2                               = %00000001

VIA_PORTB = $6000
VIA_PORTA = $6001
VIA_DDRB  = $6002
VIA_DDRA  = $6003
VIA_T1CL  = $6004
VIA_T1CH  = $6005
VIA_T1LL  = $6006
VIA_T1LH  = $6007
VIA_T2CL  = $6008
VIA_T2CH  = $6009
VIA_SR    = $600a
VIA_ACR   = $600b
VIA_PCR   = $600c
VIA_IFR   = $600d
VIA_IER   = $600e

