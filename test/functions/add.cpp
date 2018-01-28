#include "c_template/functions.h"
#include <catch.hpp>

SCENARIO("Add 2 numbers", "[functions]")
{
	GIVEN("Returns two numbers added together")
	{
		int r = add(2, 3);

		THEN("2 + 3 = 5")
		{
			REQUIRE(r == 5);
		}
	}
}
