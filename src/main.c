#include <c_template/add.h>
#include <c_template/subtract.h>
#include <c_template/version.h>

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

	printf("project info:\n"
	       "\tname: %s\n"
	       "\tdesc: %s\n"
	       "\tauthor: %s\n"
	       "\tversion: %s\n"
	       "\tmail: %s\n"
	       "\tcopyright: %s\n",
		C_TEMPLATE_NAME, C_TEMPLATE_DESCRIPTION, C_TEMPLATE_AUTHOR,
		C_TEMPLATE_VERSION, C_TEMPLATE_MAIL, C_TEMPLATE_COPYRIGHT);

	return EXIT_SUCCESS;
}
