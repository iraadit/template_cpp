# Copyright (c) 2012 - 2017, Lars Bilke
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
#    may be used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# CHANGES:
#
# 2012-01-31, Lars Bilke
# - Enable Code Coverage
#
# 2013-09-17, Joakim Söderberg
# - Added support for Clang.
# - Some additional usage instructions.
#
# 2016-02-03, Lars Bilke
# - Refactored functions to use named parameters
#
# 2017-06-02, Lars Bilke
# - Merged with modified version from github.com/ufz/ogs
#
# 2017-01-28, Rowan Goemans
# - Removed the need to setup targets. Just enable coverage then 
#   run your targets the way you like and then create a report.
#
#
# USAGE:
#
# 1. Copy this file into your cmake modules path.
#
# 2. Add the following line to your CMakeLists.txt:
#      include(CodeCoverage)
#
# 3. Build a Debug build, run it and create a report:
#      cmake -DCMAKE_BUILD_TYPE=Debug ..
#      [Compile and run the targets you want to generated coverage data for]
#      make coverage_report
#
# 4. Clear out coverage data, this resets all data to 0:
#      make coverage_clear
#

# Check prereqs
find_program(GCOV_PATH gcov )
find_program(LCOV_PATH  NAMES lcov lcov.bat lcov.exe lcov.perl)
find_program(GENHTML_PATH NAMES genhtml genhtml.perl genhtml.bat )

# Check for necessary utilities
if(NOT GCOV_PATH)
	message(FATAL_ERROR "gcov not found! Aborting...")
endif() # NOT GCOV_PATH

if(NOT LCOV_PATH)
	message(FATAL_ERROR "lcov not found! Aborting...")
endif() # NOT LCOV_PATH

if(NOT GENHTML_PATH)
	message(FATAL_ERROR "genhtml not found! Aborting...")
endif() # NOT GENHTML_PATH

if("${CMAKE_CXX_COMPILER_ID}" MATCHES "(Apple)?[Cc]lang")
	if("${CMAKE_CXX_COMPILER_VERSION}" VERSION_LESS 3)
		message(FATAL_ERROR 
			"Clang version must be 3.0.0 or greater! Aborting...")
	endif()
elseif(NOT "${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU" 
	AND NOT "${CMAKE_C_COMPILER_ID}" MATCHES "GNU")
	message(FATAL_ERROR "Compiler is not GNU gcc! Aborting..." )
endif()

set(COVERAGE_COMPILER_FLAGS "-g -O0 --coverage -fprofile-arcs -ftest-coverage"
	CACHE INTERNAL "")

set(CMAKE_CXX_FLAGS_COVERAGE
	${COVERAGE_COMPILER_FLAGS}
	CACHE STRING "Flags used by the C++ compiler during coverage builds."
	FORCE )
set(CMAKE_C_FLAGS_COVERAGE
	${COVERAGE_COMPILER_FLAGS}
	CACHE STRING "Flags used by the C compiler during coverage builds."
	FORCE )
set(CMAKE_EXE_LINKER_FLAGS_COVERAGE
	""
	CACHE STRING "Flags used for linking binaries during coverage builds."
	FORCE )
set(CMAKE_SHARED_LINKER_FLAGS_COVERAGE
	""
	CACHE STRING 
		"Flags used by the shared libraries linker during coverage builds."
	FORCE )
mark_as_advanced(
	CMAKE_CXX_FLAGS_COVERAGE
	CMAKE_C_FLAGS_COVERAGE
	CMAKE_EXE_LINKER_FLAGS_COVERAGE
	CMAKE_SHARED_LINKER_FLAGS_COVERAGE )

if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
	message(FATAL_ERROR 
		"Code coverage results is only valid with debug builds.")
endif() # NOT CMAKE_BUILD_TYPE STREQUAL "Debug"

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
	link_libraries(gcov)
else()
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COVERAGE_COMPILER_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COVERAGE_COMPILER_FLAGS}")
message(STATUS 
	"Appending code coverage compiler flags: ${COVERAGE_COMPILER_FLAGS}")

# Reset coverage
add_custom_target(coverage_clear
	# Cleanup lcov
	COMMAND ${LCOV_PATH} --directory . --zerocounters
	COMMENT "Resetting code coverage counters to zero."
)

# Setup target
add_custom_target(coverage_report
	# Create baselines to make sure untouched files show up in the report
	COMMAND ${LCOV_PATH} -q -c -i -d "\"${CMAKE_SOURCE_DIR}\"" -o coverage_report.base
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
	COMMAND ${GENHTML_PATH} -o coverage_report 
		"\"${PROJECT_BINARY_DIR}/coverage_report.info.cleaned\""
	COMMAND ${CMAKE_COMMAND} -E remove coverage_report.base
		coverage_report.info coverage_report.all coverage_report.total
		${PROJECT_BINARY_DIR}/coverage_report.info.cleaned

	WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
	DEPENDS ${Coverage_DEPENDENCIES}
	COMMENT "Processing code coverage counters and generating report."
)

# Show info where to find the report
add_custom_command(TARGET coverage_report POST_BUILD
	COMMAND ;
	COMMENT "Report is available at ./coverage_report/index.html."
)