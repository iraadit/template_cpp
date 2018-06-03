Optimising
==========

If you want to optimise CI by removing jobs, two jobs are a prime candidate.
They are ``build/clang`` and ``build/gcc``. These jobs compile the project in
a way that an end-user or distro maintainer would likely do. No CMake options
are set and the standard compiler is used with CMake's release mode flags.

By default these jobs only run in ``master``, which saves CPU time compared
to always running them. It will still help find bugs in the project's
``CMakeLists.txt`` which only occur when building in release mode or issues with
the compiler that only occur when optimisations are enabled. This avoids tagging
a broken release.
