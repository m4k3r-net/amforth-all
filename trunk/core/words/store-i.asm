; ( n addr -- ) 
; Memory
; Deferred action for flash write of a single cell
VE_STOREI:
    .dw $ff02
    .db "!i"
    .dw VE_HEAD
    .set VE_HEAD = VE_STOREI
XT_STOREI:
    .dw PFA_DODEFER
PFA_STOREI:
    .dw EE_STOREI
    .dw XT_EDEFERFETCH
    .dw XT_EDEFERSTORE
