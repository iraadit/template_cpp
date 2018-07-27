format
======

.. note::

	Requires a Unix-like environment.

When configuring with ``-DFORMAT:BOOL=ON`` targets ``format`` and
``format_check`` will be added. The ``format`` target will format all source
code in place while the ``format_check`` target only checks the code without
modifying the scode.

When also configuring with ``-DWERROR:BOOL=ON`` a nonzero exit code will be
returned if at least one line does not pass the checks while invoking
``format_check``.

The script invoked is ``/cicd/style/clang_format.sh`` and can also be used to
check source files, reporting replacements in XML.

.. code-block:: console

	# always call script from root of the repo
	./cicd/style/clang_format.sh --help
