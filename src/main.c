#include "main.h"

#include <avr/io.h>
#include <util/delay.h>

extern uint8_t *const __bss_end;
extern uint8_t *const __bss_start;

static void _Clear_BSS(void)
{
  register uint8_t *address = __bss_start;

  while (address != __bss_end)
  {
    *(address++) = 0x00;
  }
}

static void _Setup(void)
{
  DDRB = _BV(5);
  PORTB = _BV(5);
}

static void _Loop(void)
{
  PORTB ^= _BV(5);
  _delay_ms(500);
}

void ISR_Int0_Handler(void)
{
}

void ISR_Reset_Handler(void)
{
  (void) _Clear_BSS();

  (void) _Setup();

  while (true)
  {
    (void) _Loop();
  }
}
