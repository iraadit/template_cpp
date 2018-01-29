# coverage is not valid when it is not a debug build
if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
	message(FATAL_ERROR
		"Code coverage is only supported for CMAKE_BUILD_TYPE=DEBUG.")
endif()

# find coverage tools, gcov is for GCC and llvm-cov for clang
# llvm-cov has to wrapped with the gcov option
if (CMAKE_C_COMPILER_ID STREQUAL "Clang")
	find_program(LLVM_COV_PATH
		NAMES llvm-cov llvm-cov-6.0 llvm-cov-5.0
		DOC "Path to llvm-cov")

	if(NOT LLVM_COV_PATH)
		message(FATAL_ERROR "Could not find llvm-cov.")
	endif()

	set(GCOV_PATH "${CMAKE_BINARY_DIR}/llvm-cov.sh")

	# wrap llvm-cov to have behaviour like gcov
	file(WRITE "${GCOV_PATH}"
		"#!/bin/sh\nexec \"${LLVM_COV_PATH}\" gcov \"$@\"")

	execute_process(COMMAND chmod +x "${GCOV_PATH}")
elseif (CMAKE_C_COMPILER_ID STREQUAL "GNU")
	find_program(GCOV_PATH gcov)
	if(NOT GCOV_PATH)
		message(FATAL_ERROR "Could not find gcov.")
	endif()
else()
	message(FATAL_ERROR
		"Code coverage not supported for current compiler.")
endif()

find_program(LCOV_PATH lcov)
if(NOT LCOV_PATH)
	message(FATAL_ERROR "Could not find lcov.")
endif()

find_program(GENHTML_PATH genhtml)
if(NOT GENHTML_PATH)
	message(FATAL_ERROR "Could not find genhtml.")
endif()

# add necessary compile and linker flags
add_compile_options(--coverage)
if(NOT CMAKE_EXE_LINKER_FLAGS MATCHES "(^| +)--coverage($| +)")
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage"
		CACHE STRING "Linker flags for all executables." FORCE)
endif()

# Resets coverage counters.
add_custom_target(coverage_clear
	COMMAND "${LCOV_PATH}" --directory . --zerocounters
	COMMENT "Resetting coverage counters.")

# setup target
add_custom_target(coverage_report
	# create baselines to make sure untouched files show up in the report
	COMMAND "${LCOV_PATH}" -q -c -i
		--gcov-tool "\"${GCOV_PATH}\""
		-d . -o coverage_report.base

	# capturing lcov counters and generating report
	COMMAND "${LCOV_PATH}" -q
		--gcov-tool "\"${GCOV_PATH}\""
		--directory . --capture
		--output-file coverage_report.info

	# add baseline counters
	COMMAND "${LCOV_PATH}" -q
		--gcov-tool "\"${GCOV_PATH}\""
		-a coverage_report.base -a coverage_report.info
		--output-file coverage_report.total

	# exclude everything but the project sources
	COMMAND "${LCOV_PATH}" -q
		--gcov-tool "\"${GCOV_PATH}\""
		-e coverage_report.total "\"${CMAKE_SOURCE_DIR}/*\""
		--output-file coverage_report.info.cleaned

	# generate html report and remove intermediate reports.
	COMMAND "${GENHTML_PATH}"
		-o coverage_report coverage_report.info.cleaned
	COMMAND "${CMAKE_COMMAND}" -E remove coverage_report.base
		coverage_report.info coverage_report.all coverage_report.total
		coverage_report.info.cleaned

	WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
	COMMENT "Generating html report from coverage data.")

# show info where to find the report
add_custom_command(TARGET coverage_report POST_BUILD
	COMMAND ;
	COMMENT "Report is available at ./coverage_report/index.html.")
