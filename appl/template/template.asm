; This is a template for an amforth project.
; The order of the entries must not be changed since
; it is very important that the settings are in the 
; right order
;
; first is to include the macros from the amforth
; directory 
.include "macros.asm"

; amforth needs two essential parameters
; cpu clock in hertz
.equ cpu_frequency = 8000000

; size of return stack in bytes
.equ rstacksize = 80

; initial baud rate of terminal
.equ baud_rate = 9600

; the application specific dictionary can
;   - not be included, set to 0 (zero)
;   - be included in the rww section: set to 1 (one)
;   - be included in the nrww (bootsector) area: set to 2 (two)
; this  dictionary can be quite large so putting
; it into the bootsector area (NRWW) does make sense for the bigger
; atmegas only (ATmega32 and up) only

.set dict_appl=1

; include the amforth device definition file. These
; files include the *def.inc from atmel internally.
.include "devices/atmega169.asm"

; change these settings only if you know what you do.
  .set heap = ramstart
  .set VE_HEAD = $0000

; an device specific initialization which cannot
; be implemented in forth with it's TURNKEY vector.

.org codestart
device_init:
    ret

; include the whole source tree.
.include "amforth.asm"
