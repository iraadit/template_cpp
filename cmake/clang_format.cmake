find_program(CLANG_FORMAT_PATH
	NAMES clang-format
	DOC "Path to clang-format.")

if(NOT CLANG_FORMAT_PATH)
	message(FATAL_ERROR "Could not find clang-format.")
endif()
message(STATUS "Found clang-format: ${CLANG_FORMAT_PATH}")

add_custom_target(format
	COMMENT "Formatting source code"
	COMMAND ./cicd/style/clang_format.sh format "${CLANG_FORMAT_PATH}"
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")

add_custom_target(format_check
	COMMENT "Running format check"
	COMMAND WERROR=${WERROR} ./cmake/format_check.sh "${CLANG_FORMAT_PATH}"
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
