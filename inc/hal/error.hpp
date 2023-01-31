#ifndef _HAL_ERROR_H
#define _HAL_ERROR_H

#include "types.hpp"

typedef enum {
  __HAL_ErrorCode_InvalidDirection,
  __HAL_ErrorCode_InvalidPin,
} __HAL_ErrorCode_t ;

void __HAL_Handle_Error(__HAL_ErrorCode_t code);

#endif
