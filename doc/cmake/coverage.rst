coverage
========

When configuring with ``-DCOVERAGE:BOOL=ON`` compiled code will be instrumented
when ran. Usually by running the tests but running code any way, such as by the
main executable and manually doing things inside the program, will work.

Target ``coverage_report`` is also added. Running ``make coverage_report`` will
build an HTML report based upon the lines of code ran at the point of
generating.

Additionally target ``coverage_reset`` will be added. Running
``make coverage_reset`` will reset all coverage counters in preparation for
either running tests again or running code any other way.

Keep in mind counters are accumulative. If the counters are empty running the
tests twice, provided your tests are deterministic, will result in all count
events happening twice compared to running tests once. Generating a coverage
report after may result into a rather confusing report when you expect lines
being executed only ``x`` times but find out they have been executed ``2x``
times.
