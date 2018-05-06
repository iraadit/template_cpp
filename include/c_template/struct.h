#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/** \brief This is an arbitrary struct. */
struct arbitrary_struct
{
	/** \brief The amount of a in the universe. */
	uint8_t a;
	/** \brief The amount of b in the universe. */
	uint8_t b;
	/** \brief One-letter code for universe condition. */
	char c;
};

#ifdef __cplusplus
}
#endif
