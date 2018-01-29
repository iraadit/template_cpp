#pragma once

/**
 * \brief An abstract base class.
 */
class base
{
public:
	/**
	 * \brief Default constructor.
	 */
	base() = default;

	/**
	 * \brief Default virtual destructor.
	 */
	virtual ~base() = default;

	/**
	 * \brief Default copy constructor.
	 * \param b cool
	 */
	base(const base& b) = default;

	/**
	 * \brief Default move constructor.
	 * \param b
	 */
	base(base&& b) = default;

	/**
	 * \brief Default copy assignment operator.
	 * \param b
	 * \return
	 */
	base& operator=(const base& b) = default;

	/**
	 * \brief Default move assignment operator.
	 * \param b
	 * \return
	 */
	base& operator=(base&& b) = default;

	/**
	 * \brief Pure virtual member function.
	 */
	virtual void init() = 0;
};