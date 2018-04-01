# find sphinx
find_program(SPHINXBUILD_PATH
	NAMES sphinx-build
	DOC "Path to sphinx-build.")

if(NOT SPHINXBUILD_PATH)
	message(FATAL_ERROR "Could not find sphinx-build.")
endif()
message(STATUS "Found sphinx-build: ${SPHINXBUILD_PATH}")
