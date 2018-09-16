add_custom_target(line_limit
	COMMENT "Running line_limit checks"
	COMMAND WERROR=${WERROR} ./cmake/line_limit.sh
	WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}")
