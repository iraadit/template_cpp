# find sphinx
find_program(SPHINXAUTOBUILD_PATH
	NAMES sphinx-autobuild
	DOC "Path to sphinx-autobuild.")

if(NOT SPHINXAUTOBUILD_PATH)
	message(FATAL_ERROR "Could not find sphinx-autobuild.")
endif()
message(STATUS "Found sphinx-autobuild: ${SPHINXAUTOBUILD_PATH}")
