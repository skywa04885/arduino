#ifndef _GPIO_H
#define _GPIO_H

#include <stdlib.h>
#include <avr/io.h>

#include "hal/error.hpp"
#include "types.hpp"

#define HAL_GPIO_Pin_LedBuiltIn 13
#define HAL_GPIO_Pin_TxLED 5
#define HAL_GPIO_Pin_RxLED 4

#define HAL_GPIO_Pin_GetDirectionReg(PIN) \
  ((PIN >= 0 && PIN <= 7) ? DDRD : ((PIN >= 8 && PIN <= 13) ? DDRB : ((PIN >= 14 && PIN <= 19) ? DDRC : _MMIO_BYTE(0))))

#define HAL_GPIO_Pin_GetOutputRegister(PIN) \
  ((PIN >= 0 && PIN <= 7) ? PORTD : ((PIN >= 8 && PIN <= 13) ? PORTB : ((PIN >= 14 && PIN <= 19) ? PORTC : _MMIO_BYTE(0))))

#define HAL_GPIO_Pin_GetInputRegister(PIN) \
  ((PIN >= 0 && PIN <= 7) ? PIND : ((PIN >= 8 && PIN <= 13) ? PINB : ((PIN >= 14 && PIN <= 19) ? PINC : _MMIO_BYTE(0))))

#define HAL_GPIO_Pin_GetRelativePin(PIN) \
  ((PIN >= 0 && PIN <= 7) ? (PIN - 0) : ((PIN >= 8 && PIN <= 13) ? (PIN - 8) : ((PIN >= 14 && PIN <= 19) ? (PIN - 14) : 0)))

#define HAL_GPIO_Pin_GetRelativePinMask(PIN) \
  _BV(HAL_GPIO_Pin_GetRelativePin(PIN))

#define HAL_GPIO_SetDirection_Output(PIN) \
  HAL_GPIO_Pin_GetDirectionReg(PIN) |= HAL_GPIO_Pin_GetRelativePinMask(PIN)
#define HAL_GPIO_SetDirection_Input(PIN) \
  HAL_GPIO_Pin_GetDirectionReg(PIN) &= ~HAL_GPIO_Pin_GetRelativePinMask(PIN)

#define HAL_GPIO_SetLevel_High(PIN) \
  HAL_GPIO_Pin_GetOutputRegister(PIN) |= HAL_GPIO_Pin_GetRelativePinMask(PIN)
#define HAL_GPIO_SetLevel_Low(PIN) \
  HAL_GPIO_Pin_GetOutputRegister(PIN) &= ~HAL_GPIO_Pin_GetRelativePinMask(PIN)
#define HAL_GPIO_ToggleLevel(PIN) \
  HAL_GPIO_Pin_GetOutputRegister(PIN) ^= HAL_GPIO_Pin_GetRelativePinMask(PIN)

#define HAL_GPIO_InputLevel_Get(PIN) \
  (HAL_GPIO_Pin_GetInputRegister(PIN) & HAL_GPIO_Pin_GetRelativePinMask(PIN))
#define HAL_GPIO_InputLevel_IsHigh(PIN) \
  (HAL_GPIO_InputLevel_Get(PIN) != 0)
#define HAL_GPIO_InputLevel_IsLow(PIN) \
  (HAL_GPIO_InputLevel_Get(PIN) == 0)

#endif
