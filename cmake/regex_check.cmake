add_custom_target(regex_check
	COMMENT "Running regex_check checks"
	COMMAND WERROR=${WERROR} ./cmake/regex_check.sh
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
