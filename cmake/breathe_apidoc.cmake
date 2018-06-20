if(BREATHE_APIDOC_FOUND)
	return()
endif()

find_program(BREATHE_APIDOC_PATH
	NAMES breathe-apidoc
	DOC "Path to breathe-apidoc.")

if(NOT BREATHE_APIDOC_PATH)
	message(FATAL_ERROR "Could not find breathe-apidoc.")
endif()
set(BREATHE_APIDOC_FOUND ON CACHE BOOL "Found breathe-apidoc.")
mark_as_advanced(BREATHE_APIDOC_FOUND)
message(STATUS "Found breathe-apidoc: ${BREATHE_APIDOC_PATH}")
