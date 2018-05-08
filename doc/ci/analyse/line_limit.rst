analyse/line_limit
==================

.. note:: Requires an UNIX environment.

This check is not integrated with CMake. CI runs this script directly.

Used to enforce line limits for all files but code, since code it handled
by ``clang-format``. The script provides options to exclude files and lines
from checking.

It also has an option to check for consistent indentation style in which case
mixing tab and spaces for indenting within a file will cause it to emit a hit.

.. code-block:: console

	./ci/style/line_limit.sh --help
