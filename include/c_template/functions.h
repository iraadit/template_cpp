#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/// \brief Add 2 numbers together
/// 
/// \param a The left hand number to add.
/// \param b The right hand number to add.
/// \return The result of adding a to b.
uint8_t add(uint8_t a, uint8_t b);

#ifdef __cplusplus
}
#endif
