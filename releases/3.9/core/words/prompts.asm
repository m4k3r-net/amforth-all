; ( -- ) System
; R( -- )
; send the READY prompt to the command line
;VE_PROMPTRDY:
;    .dw $ff04
;    .db "p_rd"
;    .dw VE_HEAD
;    .set VE_HEAD = VE_PROMPTRDY
XT_PROMPTRDY:
    .dw DO_COLON
PFA_PROMPTRDY:
    .dw XT_CR
    .dw XT_SLITERAL
    .dw 2
    .db "> "
    .dw XT_ITYPE
    .dw XT_EXIT

; ( -- ) System
; R( -- )
; send the OK prompt to the command line
;VE_PROMPTOK:
;    .dw $ff04
;    .db "p_ok"
;    .dw VE_HEAD
;    .set VE_HEAD = VE_PROMPTOK
XT_PROMPTOK:
    .dw DO_COLON
PFA_PROMPTOK:
    .dw XT_SLITERAL
    .dw 3
    .db " ok",0
    .dw XT_ITYPE
    .dw XT_EXIT

; ( n -- ) System
; R( -- )
; process the error prompt
;VE_PROMPTERROR:
;    .dw $ff04
;    .db "p_er"
;    .dw VE_HEAD
;    .set VE_HEAD = VE_PROMPTERROR
XT_PROMPTERROR:
    .dw DO_COLON
PFA_PROMPTERROR:
.if want_fun
	.dw XT_G_IN
	.dw XT_FETCH
	.dw XT_SPACES
	.dw XT_DOLITERAL
	.dw '^'
	.dw XT_EMIT
	.dw XT_CR
.endif
	.dw XT_SLITERAL
	.dw 4
	.db  " ?? "
        .dw XT_ITYPE
	.dw XT_BASE
	.dw XT_FETCH
	.dw XT_TO_R
	.dw XT_DECIMAL
	.dw XT_DOT
	.dw XT_G_IN
	.dw XT_FETCH
	.dw XT_DOT
	.dw XT_R_FROM
	.dw XT_BASE
	.dw XT_STORE
    .dw XT_EXIT
