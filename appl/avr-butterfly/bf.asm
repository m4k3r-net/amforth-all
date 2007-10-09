; Settings for the avr butterfly demo board
.include "macros.asm"

; cpu clock in hertz
.equ cpu_frequency = 8000000
; baud rate of terminal
.equ baud_rate = 9600

; size of return stack in bytes
.equ rstacksize = 80

.set dict_appl=1

.include "devices/atmega169.asm"

  .set heap = ramstart
  .set VE_HEAD = $0000

.include "amforth.asm"
