# 3.8.2 required for CMAKE_CXX_STANDARD 17
cmake_minimum_required(VERSION 3.8.2 FATAL_ERROR)
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# set build type to release if none is specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
	set(CMAKE_BUILD_TYPE Release CACHE STRING
		"Choose the type of build." FORCE)
	set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
		"Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# options
option(CLANG_TIDY "Check code with clang-tidy." OFF)
option(CODE "Build primary libraries and executables." ON)
option(COVERAGE "Instrument code with coverage flags." OFF)
option(FORMAT "Add \"format\" target which runs clang-format." OFF)
option(FLAWFINDER "Add \"flawfinder\" target which checks code." OFF)
option(LINE_LIMIT "Check files with line_limit." OFF)
option(REGEX_CHECK "Check files with regex_check." OFF)
option(SANITISE "Add -fsanitize=address and -fsanitize=undefined flags." OFF)
option(TEST "Build unit and functional tests." OFF)
option(WERROR "Make all warnings into errors." OFF)
if(NOT DEFINED DOC)
	set(DOC OFF CACHE STRING
		"The documentation type to generate." FORCE)
endif()

# disable base languages
unset(PROJECT_LANGUAGES)

if(${CODE})
	set(PROJECT_LANGUAGES ${PROJECT_LANGUAGES} C)
endif()

# test framework requires c++
if(${TEST})
	set(PROJECT_LANGUAGES ${PROJECT_LANGUAGES} CXX)
endif()

project(c_template
	VERSION 1.9.1
	DESCRIPTION "__DESCRIPTION__"
	LANGUAGES ${PROJECT_LANGUAGES})
set(PROJECT_VERSION_SUFFIX "") # alpha/beta/rc, e.g. "-rc0"
set(PROJECT_VERSION "${PROJECT_VERSION}${PROJECT_VERSION_SUFFIX}")
set(PROJECT_AUTHOR "__AUTHOR__")
set(PROJECT_COPYRIGHT "__COPYRIGHT__")
set(PROJECT_MAIL "__AUTHOR_MAIL__")
# only set CMAKE variant when local name matches CMAKE name
# this avoids clashing when being used as a subproject
if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
	set(CMAKE_PROJECT_VERSION "${PROJECT_VERSION}")
	set(CMAKE_PROJECT_VERSION_SUFFIX "${PROJECT_VERSION_SUFFIX}")
	set(CMAKE_PROJECT_AUTHOR "${PROJECT_AUTHOR}")
	set(CMAKE_PROJECT_COPYRIGHT "${PROJECT_COPYRIGHT}")
	set(CMAKE_PROJECT_MAIL "${PROJECT_MAIL}")
endif()
include(version)
include(version_header)

if(${CODE})
	include(code)
	include(package)
elseif(${CLANG_TIDY} OR ${COVERAGE} OR ${SANITISE} OR ${TEST})
	message(FATAL_ERROR "At least one flag enabled that requires CODE=ON.")
endif()

if(NOT DOC STREQUAL "OFF")
	add_subdirectory(doc)
endif()

if(${FORMAT})
	include(clang_format)
endif()

if(${FLAWFINDER})
	include(flawfinder)
endif()

if(${LINE_LIMIT})
	include(line_limit)
endif()

if(${REGEX_CHECK})
	include(regex_check)
endif()

if(${LINE_LIMIT} OR ${REGEX_CHECK} OR ${FLAWFINDER} OR ${FORMAT})
	include(check)
endif()
