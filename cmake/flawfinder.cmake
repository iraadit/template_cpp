find_program(FLAWFINDER_PATH
	NAMES flawfinder
	DOC "Path to flawfinder.")

if(NOT FLAWFINDER_PATH)
	message(FATAL_ERROR "Could not find flawfinder.")
endif()
message(STATUS "Found flawfinder: ${FLAWFINDER_PATH}")

if(${WERROR})
	set(OPT "--error-level=1")
else()
	unset(OPT)
endif()

add_custom_target(flawfinder
	COMMAND "${FLAWFINDER_PATH}" -m 1 -C -c -D -Q ${OPT} -- .
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
