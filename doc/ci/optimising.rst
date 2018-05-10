Optimising
==========

If you want to optimise CI by removing jobs, two jobs are a prime candidate.
They are ``build/clang`` and ``build/gcc``. These jobs compile the project in
a way that an end-user or distro maintainer would likely do. No CMake options
are set and the standard compiler is used with CMake's release mode flags.

You could also set these jobs to run only for the master branch so you still
avoid broken things before tagging a release.
