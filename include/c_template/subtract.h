#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/**
 * Subtract 2 numbers from another.
 * \param a The left hand number to subtract.
 * \param b The right hand number to subtract.
 * \return The result of subtracting b from a.
 */
int16_t subtract(uint8_t a, uint8_t b);

#ifdef __cplusplus
}
#endif
