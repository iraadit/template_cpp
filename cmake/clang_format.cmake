# find clang-format
find_program(CLANG_FORMAT_PATH
	NAMES clang-format
	DOC "Path to clang-format.")

# error if not found
if(NOT CLANG_FORMAT_PATH)
	message(FATAL_ERROR "Could not find clang-format.")
endif()
message(STATUS "Found clang-format: ${CLANG_FORMAT_PATH}")

# add target
add_custom_target(format
	COMMAND ./ci/clang_format.sh format "${CLANG_FORMAT_PATH}"
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
