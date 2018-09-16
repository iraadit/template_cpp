macOS OSXCross
==============

.. important::

	Usage of Xcode components and the macOS SDK is subject to a legal
	agreement. Refer to https://www.apple.com/legal/sla/docs/xcode.pdf for
	details.

.. warning::

	The current version of the template does not run tests of the project
	under the target platform. This would require physical or virtual macOS
	machines to be available for running CICD jobs which the authors of the
	template currently do not have resources for.

	**Cross-compiled binaries are untested and may or may not work
	properly.**

.. note::

	The MacPorts Packet Manager provided by OSXCross is currently not
	integrated. This shouldn't be a problem, since manual package management
	is required to support other platforms anyway.

The OSXCross cross compiler is used to compile native ``x86_64`` macOS binaries
from a GNU/Linux host environment. The job in question in ``osxcross_x86_64`` in
the ``package`` stage.

Refer to the upstream OSXCross website for details:
https://github.com/tpoechtrager/osxcross.

Other architectures
-------------------

By default the template only compiles for the ``x86_64`` architecture, commonly
known as "64-bit macOS". Compiling for ``i386``, or "32-bit macOS", is also
possible. The docker target ``osxcross_i386_x86_64`` contains compilers for both
architectures. All that is required is adding a new CICD job and setting the
toolchain file option to the ``i386`` variant.

Support for old PowerPC variants of macOS has been dropped for a considerable
amount of time. Neither Apple nor the OSXCross project support said PowerPC
variants.
