sanitise
========

.. note::

	LSan uses ptrace to attach a tracer thread to the program that is
	being tested. Docker containers run without the SYS_PTRACE capability
	by default. In order for the CI to work properly the docker container
	should be run with the SYS_PTRACE capability. See
	https://docs.docker.com/engine/reference/run on how to add specific
	capabilities.

When configuring with ``-DSANITISE:BOOL=ON`` AddressSanitiser (ASAN) and
UndefinedBehaviourSanitiser (UBSAN) will be enabled. The compiler flags for
these are ``-fsanitize=address`` and ``-fsanitize=undefined`` respectively.

When also configuring with ``-DWERROR:BOOL=ON`` compiler flag
``-fno-sanitize-recover=all`` is added which will usually cause the program to
terminate after the first error in addition to returning a non-zero exit code.
