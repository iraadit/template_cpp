sanitise
========

When configuring with ``-DSANITISE:BOOL=ON`` AddressSanitiser (ASAN) and
UndefinedBehaviourSanitiser (UBSAN) will be enabled. The compiler flags for
these are ``-fsanitize=address`` and ``-fsanitize=undefined`` respectively.

When also configuring with ``-DWERROR:BOOL=ON`` compiler flag
``-fno-sanitize-recover=all`` is added which will usually cause the program to
terminate after the first error in addition to returning a non-zero exit code.
