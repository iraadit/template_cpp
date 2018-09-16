Windows Mingw-W64
=================

.. warning::

	The current version of the template does not run tests of the project
	under the target platform. This would require physical or virtual
	Windows machines to be available for running CICD jobs which the authors
	of the template currently do not have resources for.

	**Cross-compiled binaries are untested and may or may not work
	properly.**

The Mingw-W64 cross compiler is used to compile native ``x86_64`` Windows
binaries from a GNU/Linux host environment. The job in question in
``mingw_x86_64`` in the ``package`` stage.

Refer to the upstream Mingw-W64 website for details: https://mingw-w64.org/.

Other architectures
-------------------

By default the template only compiles for the ``x86_64`` architecture, commonly
known as "64-bit Windows". Compiling for ``i686``, or "32-bit Windows", is also
possible. Simply copy the ``mingw_w64_x86_64`` docker target as
``mingw_w64_i686`` and change the ``x86-64`` prefix for all packages into
``-i686``. Finally create a new cross-compiler definition in ``cmake/cross`` and
add a CICD job.

For other, rare, architectures of Windows such as ARM you will need to obtain or
build a cross-compiler yourself. The Mingw-W64 project only handles the ``i686``
and ``x86_64`` architectures.
