#include <stdio.h>

#include <c_template/functions.h>

int main(int argc, char **argv)
{
	/* print some floating points */
	float f = 3.14f;
	double d = 3.14;
	long double ld = 3.14l;
	printf("%f\n", (double)f);
	printf("%f\n", d);
	printf("%f\n", (double)ld);

	/* print arg count */
	printf("argc: %i\n", argc);

	/* print args */
	printf("argv:\n");
	for (int i = 0; i < argc; ++i) {
		printf("\t%i: ", i);
		printf("%s\n", argv[i]);
	}

	/* use external function to return */
	return return_zero();
}
