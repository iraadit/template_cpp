#include "c_template/functions.h"
#include <catch.hpp>

SCENARIO("add two numbers", "[functions]")
{
	GIVEN("two numbers are added.")
	{
		int r = add(2, 3);

		THEN("their sum is returned")
		{
			REQUIRE(r == 5);
		}
	}
}
