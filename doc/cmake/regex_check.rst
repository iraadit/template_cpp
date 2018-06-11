regex_check
===========

.. note:: Requires a Unix-like environment.

When configuring with ``-DREGEX_CHECK:BOOL=ON`` target ``regex_check`` will be
added. The target will invoke the ``regex_check.sh`` script.

When also configuring with ``-DWERROR:BOOL=ON`` a nonzero exit code will be
returned if at least one line does not pass the checks.

Used to check for non-ASCII characters in source code and documentation.
The script provides options to exclude files and lines from checking.

Another invocation is used with a custom regex which will find trailing
whitespace, or actually anything that is not a control or blank character.

.. code-block:: console

	./cicd/style/regex_check.sh --help
