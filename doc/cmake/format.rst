format
======

.. note:: Requires a Unix-like environment.

When configuring with ``-DFORMAT:BOOL=ON`` target ``format`` will be added.
Running ``make format`` will then format all source code in place.

The script invoked is ``/ci/clang_format.sh`` and can also be used to check
source files, reporting replacements in XML.

.. code-block:: console

	# always call script from root of the repo
	./ci/clang_format.sh --help
