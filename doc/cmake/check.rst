check
=====

When configuring with either

* ``-DLINE_LIMIT:BOOL=ON`` or,
* ``-DREGEX_CHECK:BOOL=ON`` or,
* ``-DFLAWFINDER:BOOL=ON`` or,
* ``-DFORMAT:BOOL=ON``

an additional target ``check`` will be added. This target is a simple
convenience target that will call the above mentioned checks if they are
enabled.
