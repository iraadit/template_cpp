#include "c_template/functions.h"
#include <catch.hpp>

SCENARIO("Add two numbers", "[functions]")
{
	GIVEN("Two numbers are added.")
	{
		int r = add(2, 3);

		THEN("Their sum is returned.")
		{
			REQUIRE(r == 5);
		}
	}
}
