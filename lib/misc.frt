\ some definitions that may be useful

: within? ( n lo hi -- f )
    >r 1- over < swap r> 1+ < and 
;


\ dump flash content
: idump ( addr len -- )
    base @ >r hex
    0 do
	i 
	    over +  dup 5 u.r
	    i@ 5 u.r
	    cr
    loop
    drop
    r> base !
;

: .(  \ (s -- )
   [char] ) word count type
; immediate

\ dump free ressources
: .res ( -- ) 
    base @ >r
    decimal
	." free FLASH cells      " unused u. cr
	." free RAM cells        " sp@ heap e@ - u. cr
	." used EEPROM cells     " edp e@ u. cr
	." used data stack cells " depth u. cr
	." used return stack     " rp0 rp@ - 1- 1- u. cr
	." free return stack     " rp@ sp0 - 1+ 1+ u. cr
    r> base !
;


\ calculates the baudrate register values
\ the two bytes of the result should be
\ transferred in high - low order

\ ( baudrate -- baud-rate-register)
: calc-baudrate
    f_cpu
    d2/ d2/ d2/ d2/
    rot um/mod
    swap drop 1-
;