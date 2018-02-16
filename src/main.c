#include <c_template/add.h>
#include <c_template/subtract.h>

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

static const uint8_t A = 4;
static const uint8_t B = 37;

int main(int argc, char **argv)
{
	int i;

	printf("argc: %i\n", argc);
	for (i = 0; i < argc; ++i) {
		printf("argv[%i]: %s\n", i, argv[i]);
	}

	printf("add(%" PRIu8 ", %" PRIu8 ") = %" PRIu16 "\n", A, B, add(A, B));

	printf("subtract(%" PRIu8 ", %" PRIu8 ") = %" PRIi16 "\n", A, B,
		subtract(A, B));

	return EXIT_SUCCESS;
}
