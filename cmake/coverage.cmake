# check prereqs
find_program(GCOV_PATH gcov)
if(NOT GCOV_PATH)
	message(FATAL_ERROR "Could not find gcov.")
endif()

find_program(LCOV_PATH lcov)
if(NOT LCOV_PATH)
	message(FATAL_ERROR "Could not find lcov.")
endif()

find_program(GENHTML_PATH genhtml)
if(NOT GENHTML_PATH)
	message(FATAL_ERROR "Could not find genhtml.")
endif()

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
	message(FATAL_ERROR 
		"Code coverage is only supported for CMAKE_BUILD_TYPE=DEBUG.")
endif()

set(CMAKE_EXE_LINKER_FLAGS "--coverage" CACHE INTERNAL "" FORCE)
add_compile_options(--coverage)

# clear coverage
add_custom_target(coverage_clear
	COMMAND ${LCOV_PATH} --directory . --zerocounters
	COMMENT "Clearing coverage."
)

# setup target
add_custom_target(coverage_report

	# create baselines to make sure untouched files show up in the report
	COMMAND ${LCOV_PATH} -q -c -i -d 
		. -o coverage_report.base

		# capturing lcov counters and generating report
	COMMAND ${LCOV_PATH} -q --directory . --capture 
	--output-file coverage_report.info

	# add baseline counters
	COMMAND ${LCOV_PATH} -q 
		-a coverage_report.base -a coverage_report.info
		--output-file coverage_report.total

	# exclude everything but the project sources
	COMMAND ${LCOV_PATH} -q
		-e coverage_report.total "\"${CMAKE_SOURCE_DIR}/*\""
		--output-file coverage_report.info.cleaned
	COMMAND ${GENHTML_PATH} 
		-o coverage_report coverage_report.info.cleaned
	COMMAND ${CMAKE_COMMAND} -E remove coverage_report.base
		coverage_report.info coverage_report.all coverage_report.total
		coverage_report.info.cleaned

	WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
	DEPENDS ${Coverage_DEPENDENCIES}
	COMMENT "Handling coverages files and building html report."
)

# show info where to find the report
add_custom_command(TARGET coverage_report POST_BUILD
	COMMAND ;
	COMMENT "Report is available at ./coverage_report/index.html."
)