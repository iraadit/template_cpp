flawfinder
==========

When configuring with ``-DFLAWFINDER:BOOL=ON`` target ``flawfinder`` will be
added. The target will check all source code for potential security flaws.

When also configuring with ``-DWERROR:BOOL=ON`` a nonzero exit code will be
returned if at least one potential flaw has been detected.
