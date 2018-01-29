#include <c_template/inheritance/derived.hpp>

namespace inheritance
{
std::string class_types_to_string(class_type t)
{
	switch (t) {
	case class_type::INTERFACE:
		return "INTERFACE";
	case class_type::ABSTRACT:
		return "ABSTRACT";
	case class_type::NORMAL:
		return "NORMAL";
	default:
		return "unknown class type";
	}
}

void derived::init()
{
}
}
