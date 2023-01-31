#include "main.hpp"
#include "hal/gpio.hpp"

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
  HAL_GPIO_SetDirection_Output(HAL_GPIO_Pin_LedBuiltIn);
}

static void _Loop(void)
{
  HAL_GPIO_ToggleLevel(HAL_GPIO_Pin_LedBuiltIn);
  _delay_ms(500);
}

extern "C" void ISR_Int0_Handler(void)
{
}

extern "C" void ISR_Reset_Handler(void)
{
  (void) _Clear_BSS();

  (void) _Setup();

  while (true)
  {
    (void) _Loop();
  }
}
