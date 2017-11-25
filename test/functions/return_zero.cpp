#include "c_template/functions.h"
#include <catch.hpp>

SCENARIO("return zero", "[functions]")
{
	GIVEN("return zero is called")
	{
		uint8_t r = return_zero();

		THEN("zero is returned")
		{
			REQUIRE(r == 0);
		}
	}
}
