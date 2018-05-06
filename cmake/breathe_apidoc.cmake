find_program(BREATHE_APIDOC_PATH
	NAMES breathe-apidoc
	DOC "Path to breathe-apidoc.")

if(NOT BREATHE_APIDOC_PATH)
	message(FATAL_ERROR "Could not find breathe-apidoc.")
endif()
message(STATUS "Found breathe-apidoc: ${BREATHE_APIDOC_PATH}")
