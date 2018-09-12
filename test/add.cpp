#include <c_template/add.h>
#include <catch2/catch.hpp>

SCENARIO("add two numbers", "[add]")
{
	GIVEN("two numbers")
	{
		uint8_t a = 3;
		REQUIRE(a == 3);

		uint8_t b = 5;
		REQUIRE(b == 5);

		WHEN("they are added together")
		{
			uint16_t add1 = add(a, b);
			uint16_t add2 = add(b, a);

			THEN("the result is correct")
			{
				REQUIRE(add1 == a + b);
				REQUIRE(add2 == a + b);
			}
		}
	}
}
