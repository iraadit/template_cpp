#include "c_template/base.hpp"
#include "c_template/inheritance/derived.hpp"
#include <catch.hpp>

#include <memory>

SCENARIO("Polymorphic classes", "[inheritance]")
{
	GIVEN("one class that derives from an abstract base")
	{
		auto der = std::make_shared<inheritance::derived>();
		REQUIRE(der);

		WHEN("derived class is cast to base.") {
			auto base = std::dynamic_pointer_cast<::base>(der);

			THEN("the abstract base can be used.") {
				REQUIRE(base);
				base->init();
			}
		}
	}
}
