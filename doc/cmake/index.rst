CMake build system
==================

Below is a list of all possible options that can be configured in CMake. Their
effect on the build and integrations with other options is also described.

.. toctree::
	:glob:

	*

In case you haven't used CMake before, there are three tools to configure:

* ``cmake``
	* command-line interface, have to specify all options at once
* ``ccmake``
	* curses interface, can see the options and select them
* ``cmake-gui``
	* Qt interface, can see the options and select them

Typically an interactive interface is used, unless CMake is being used in a
script or similar automated style. Below example uses ``ccmake`` in a Unix-like
environment. Using ``cmake-gui`` is also possible, no command line is needed in
that case.

.. code-block:: console

	# the current directory must be the root of the repo
	mkdir build
	cd build

	# configure, set desired options, configure and generate
	ccmake ..

	# from here on it depends on the generator used
	# below example is for the "Unix Makefiles" generator
	make help
