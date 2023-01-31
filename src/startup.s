.extern ISR_Int0_Handler
.extern ISR_Reset_Handler

.equ sph, 0x3E
.equ spl, 0x3D
.equ sreg, 0x3F

.equ ramend, 0x08FF

.section .text

.globl __ISR_Vector_Table
.type __ISR_Vector_Table, %function
__ISR_Vector_Table:
  rjmp __ISR_Reset_Handler      ; RESET
  rjmp __ISR_Int0_Handler       ; INT0
  rjmp __ISR_Default_Handler    ; INT1
  rjmp __ISR_Default_Handler    ; INT0
  rjmp __ISR_Default_Handler    ; PCINT1
  rjmp __ISR_Default_Handler    ; PCINT2
  rjmp __ISR_Default_Handler    ; WDT
  rjmp __ISR_Default_Handler    ; TIMER2 COMPA
  rjmp __ISR_Default_Handler    ; TIMER2 COMPB
  rjmp __ISR_Default_Handler    ; TIMER2 OVF
  rjmp __ISR_Default_Handler    ; TIMER1 CAPT
  rjmp __ISR_Default_Handler    ; TIMER1 COMPA
  rjmp __ISR_Default_Handler    ; TIMER1 COMPB
  rjmp __ISR_Default_Handler    ; TIMER1 OVF
  rjmp __ISR_Default_Handler    ; TIMER0 COMPA
  rjmp __ISR_Default_Handler    ; TIMER0 COMPB
  rjmp __ISR_Default_Handler    ; TIMER0 OVF
  rjmp __ISR_Default_Handler    ; SPI, STC
  rjmp __ISR_Default_Handler    ; USART, RX
  rjmp __ISR_Default_Handler    ; USART, UDRE
  rjmp __ISR_Default_Handler    ; USART, TX
  rjmp __ISR_Default_Handler    ; ADC
  rjmp __ISR_Default_Handler    ; EE READY
  rjmp __ISR_Default_Handler    ; ANALOG COMP
  rjmp __ISR_Default_Handler    ; TWI
  rjmp __ISR_Default_Handler    ; SPM READY
.size __ISR_Vector_Table, .-__ISR_Vector_Table

; Handles the INT0 interrupt.
.globl __ISR_Int0_Handler
.type __ISR_Int0_Handler, %function
__ISR_Int0_Handler:
  ; Stores the value of SREG on the stack.
  in    r30,    sreg            ; Stores the value of SREG in R30.
  push  r30                     ; Pushes the value of R30  on the stack.
  ; Calls the interrupt handler.
  jmp   ISR_Int0_Handler
  ; Restores the value of SREG from the stack.
  pop   r30                     ; Pops the value of the previous SREG from the stack into r30.
  out   sreg,   r30             ; Puts the previous value of SREG back into SREG.
  ; Returns form from the interrupt.
  reti
.size __ISR_Int0_Handler, .-__ISR_Int0_Handler

; Handles an interrupt for which we haven't set a proper handler.
.globl __ISR_Default_Handler
.type __ISR_Default_Handler, %function
__ISR_Default_Handler:
  rjmp  .-2                     ; Stays in loop forever.
.size __ISR_Default_Handler, .-__ISR_Default_Handler

; Handles the reset interrupt.
.globl __ISR_Reset_Handler
.type __ISR_Reset_Handler, %function
__ISR_Reset_Handler:
  ; Sets the stack pointer to the highest point in the ATMEGA328P memory.
  __ISR_Reset_Handler__init_stack_pointer:
  ldi   r20,    ((ramend >> 0x00) & 0xFF)     ; Loads the least significant byte of the stack pointer to the r20 register.
  out   spl,    r20                           ; Sets the least significant byte of the stack pointer.
  ldi   r20,    ((ramend >> 0x08) & 0xFF)     ; Loads the most significant byte of the stack pointer to the r20 register.
  out   sph,    r20                           ; Sets the most significant byte of the stack pointer.

  ; Enables interrupts
  sei

  ; Jumps to the main function.
  jmp   ISR_Reset_Handler
.size __ISR_Reset_Handler, .-__ISR_Reset_Handler

