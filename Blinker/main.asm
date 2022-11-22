;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

; Blink between port 1.0 and 4.7 , alternating.

			bis.b #001h, &P1DIR
			bis.b #080h, &P4DIR ; Set both ports.

			xor.b #080h, &P4OUT ; Toggle port 4.7 to blink first.

BlinkLoop	xor.b #001h, &P1OUT ; Toggle blink state on both.
			xor.b #080h, &P4OUT	; Since port 4.7 was set to blink first, this will make them alternate.
 			mov.w #074000, R15 ; Set value to wait/delay. (Basically infinite loop this amount of times)

Delay 		dec.w R15

 			jnz Delay ; Continually decrement until R15 is 0.
 			jmp BlinkLoop
 			nop

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
