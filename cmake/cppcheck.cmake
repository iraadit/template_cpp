# find cppcheck
find_program(CPPCHECK_PATH
	NAMES cppcheck
	DOC "Path to cppcheck.")

# error if not found
if(NOT CPPCHECK_PATH)
	message(FATAL_ERROR "Could not find cppcheck.")
endif()
message(STATUS "Found cppcheck: ${CPPCHECK_PATH}")

# support WERROR
if(${WERROR})
	set(OPT "--error-exitcode=1")
else()
	unset(OPT)
endif()

# add target
add_custom_target(cppcheck
	COMMAND "${CPPCHECK_PATH}" -q --enable=all
		--project="${CMAKE_BINARY_DIR}"/compile_commands.json
		--suppressions-list=.cppcheck-suppress ${OPT}
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
