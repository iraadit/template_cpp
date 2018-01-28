#include "c_template/add.h"
#include <catch.hpp>

SCENARIO("add two numbers", "[functions]")
{
	GIVEN("two numbers")
	{
		uint8_t a = 3;

		REQUIRE(a == 3);

		uint8_t b = 5;

		REQUIRE(b == 5);

		WHEN("they are added together") {
			uint16_t added = add(a, b);
			
			THEN("The sum is both numbers added together") {
				REQUIRE(added == (a + b));
			}
		}
	}
}
