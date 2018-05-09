build/gcc
=========

This is how the project would be built on a non-developer machine where the
default compiler is GCC. No other options are set.

If you want to optimise CI by removing jobs, this is a prime candidate. You
could also set this job to only run for the master branch so you still avoid
broken things before tagging a release.
