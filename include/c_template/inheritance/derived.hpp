#pragma once

#include "../base.hpp"
#include <string>

namespace inheritance
{

/**
 * \brief Defines some known class types.
 */
enum class class_type {
	/**
	 * \brief Has no implementation.
	 */
	INTERFACE,

	/**
	 * \brief Has some implementation.
	 */
	ABSTRACT,

	/**
	 * \brief Has only implementation.
	 */
	NORMAL
};

/**
 * \brief struct containing a min and a max.
 */
struct range
{
	/**
	 * \brief The minimum value.
	 */
	std::uint8_t min;

	/**
	 * \brief The maximum value.
	 */
	std::uint8_t max;
};

/**
 * \brief Convert class_type to a string representation.
 *
 * \param t The type to translate.
 * \return The string variant.
 */
std::string class_types_to_string(class_type t);

/**
 * \brief Class that derives from an abstract base
 */
class derived : public base
{
public:
	/**
	 * \brief Default constructor.
	 */
	derived() = default;

	~derived() override = default;

	/**
	 * \brief Default copy constructor
	 * \param d
	 */
	derived(const derived& d) = default;

	/**
	 * \brief Default move constructor.
	 * \param d
	 */
	derived(derived&& d) = default;

	/**
	 * \brief Default copy assignment operator.
	 * \param d
	 * \return
	 */
	derived& operator=(const derived& d) = default;

	/**
	 * \brief Default move assignment operator.
	 * \param d
	 * \return
	 */
	derived& operator=(derived&& d) = delete;

	/**
	 * \brief Implemented function
	 */
	void init() override;
};

}
