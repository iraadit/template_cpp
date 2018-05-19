line_limit
==========

.. note:: Requires a Unix-like environment.

When configuring with ``-DLINE_LIMIT:BOOL=ON`` target ``line_limit`` will be 
added.

Used to enforce line limits for all files in the repository. The script
provides options to exclude files and lines from checking.

It also has an option to check for consistent indentation style in which case
mixing tab and spaces for indenting within a file will cause it to emit a hit.

Multiple passes are used since indent checking is disabled for source code, as
in ``.c .cpp .h .hpp``. This avoids potential conflicts with the formatter.

.. code-block:: console

	./ci/style/line_limit.sh --help
