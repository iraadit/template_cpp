# Check prereqs
find_program(GCOV_PATH gcov)
if(NOT GCOV_PATH)
	message(FATAL_ERROR "gcov not available...")
endif()

find_program(LCOV_PATH lcov)
if(NOT LCOV_PATH)
	message(FATAL_ERROR "lcov not available...")
endif()

find_program(GENHTML_PATH genhtml)
if(NOT GENHTML_PATH)
	message(FATAL_ERROR "genhtml not available...")
endif()

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
	message(FATAL_ERROR 
		"Code coverage is only supported for CMAKE_BUILD_TYPE=DEBUG.")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")
message(STATUS 
	"Appending code coverage compiler flags: --coverage")

# Reset coverage
add_custom_target(coverage_clear
	# Cleanup lcov
	COMMAND ${LCOV_PATH} --directory . --zerocounters
	COMMENT "Resetting coverage."
)

# Setup target
add_custom_target(coverage_report
	# Create baselines to make sure untouched files show up in the report
	COMMAND ${LCOV_PATH} -q -c -i -d 
		. -o coverage_report.base
	# Capturing lcov counters and generating report
	COMMAND ${LCOV_PATH} -q --directory . --capture 
	--output-file coverage_report.info

	# Add baseline counters
	COMMAND ${LCOV_PATH} -q 
		-a coverage_report.base -a coverage_report.info
		--output-file coverage_report.total

	# Exclude everything but the project sources.
	COMMAND ${LCOV_PATH} -q
		-e coverage_report.total "\"${CMAKE_SOURCE_DIR}/*\""
		--output-file coverage_report.info.cleaned
	COMMAND ${GENHTML_PATH} -o coverage_report coverage_report.info.cleaned
	COMMAND ${CMAKE_COMMAND} -E remove coverage_report.base
		coverage_report.info coverage_report.all coverage_report.total
		coverage_report.info.cleaned

	WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
	DEPENDS ${Coverage_DEPENDENCIES}
	COMMENT "Handling coverages files and building html report."
)

# Show info where to find the report
add_custom_command(TARGET coverage_report POST_BUILD
	COMMAND ;
	COMMENT "Report is available at ./coverage_report/index.html."
)