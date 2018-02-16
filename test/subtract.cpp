#include <c_template/subtract.h>
#include <catch/catch.hpp>

SCENARIO("subtract two numbers", "[subtract]")
{
	GIVEN("two numbers")
	{
		uint8_t a = 7;
		REQUIRE(a == 7);

		uint8_t b = 9;
		REQUIRE(b == 9);

		WHEN("they are subtracted from another")
		{
			int16_t sub1 = subtract(a, b);
			int16_t sub2 = subtract(b, a);

			THEN("the result is correct")
			{
				REQUIRE(sub1 == a - b);
				REQUIRE(sub2 == b - a);
			}
		}
	}
}
