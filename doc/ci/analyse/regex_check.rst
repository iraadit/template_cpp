regex_check
===========

.. note:: Requires an UNIX environment.

This check is not integrated with CMake. CI runs this script directly.

Used to check for non-ASCII characters in source code and documentation.
The script provides options to exclude files and lines from checking.

Another invocation is used with a custom regex which will find trailing
whitespace, or actually anything that is not a control or blank character.

.. code-block:: console

	./ci/style/regex_check.sh --help
