#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/** This is an arbitrary struct. */
struct arbitrary_struct
{
	/** The amount of a in the universe. */
	uint8_t a;
	/** The amount of b in the universe. */
	uint8_t b;
	/** One-letter code for universe condition. */
	char c;
};

#ifdef __cplusplus
}
#endif
