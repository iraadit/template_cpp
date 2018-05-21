find_program(CLANG_FORMAT_PATH
	NAMES clang-format
	DOC "Path to clang-format.")

if(NOT CLANG_FORMAT_PATH)
	message(FATAL_ERROR "Could not find clang-format.")
endif()
message(STATUS "Found clang-format: ${CLANG_FORMAT_PATH}")

add_custom_target(format
	COMMENT "Formatting source code"
	COMMAND ./ci/clang_format.sh format "${CLANG_FORMAT_PATH}"
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")

add_custom_target(format_check
	COMMENT "Checking if source code meets format standards"
	COMMAND WERROR=${WERROR} ./cmake/format_check.sh
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
