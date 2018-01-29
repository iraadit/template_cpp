#pragma once

#include "../base.hpp"

namespace inheritance
{

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

	void init() override;
};

}
