; ( -- )
VE_HEX:
    .db $03, "hex"
    .dw VE_LATEST
    .set VE_LATEST = VE_HEX
XT_HEX:
    .dw DO_COLON
PFA_HEX:
    .dw XT_DOLITERAL
    .dw 16
    .dw XT_BASE
    .dw XT_STORE
    .dw XT_EXIT
