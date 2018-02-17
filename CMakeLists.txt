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
option(CPPCHECK "Add \"cppcheck\" target which checks code." OFF)
option(FORMAT "Add \"format\" target which runs clang-format." OFF)
option(SANITISE "Add -fsanitize=address and -fsanitize=undefined flags." OFF)
option(TEST "Build unit and functional tests." OFF)
option(WERROR "Make all warnings into errors." OFF)
if (NOT DOC)
	set(DOC OFF CACHE STRING
		"The documentation type to generate. \"help\" for types." FORCE)
endif()

# disable base languages
unset(PROJECT_LANGUAGES)

# enable c, c++ if building main code
if(${CODE})
	set(PROJECT_LANGUAGES ${PROJECT_LANGUAGES} C CXX)
endif()

# declare project
project(cpp_template
	VERSION 1.2.0
	DESCRIPTION "Template for C++"
	LANGUAGES ${PROJECT_LANGUAGES})
set(CMAKE_PROJECT_AUTHOR "Melvin Vermeeren")
set(CMAKE_PROJECT_COPYRIGHT "2018, ${CMAKE_PROJECT_AUTHOR}")
set(CMAKE_PROJECT_MAIL "mail@mel.vin")

# main code if enabled
if(${CODE})
	include(code)
elseif(${CLANG_TIDY} OR ${COVERAGE} OR ${CPPCHECK} OR ${SANITISE} OR ${TEST})
	message(FATAL_ERROR "At least one flag enabled that requires CODE=ON.")
endif()

# doc
if(NOT DOC STREQUAL "OFF")
	add_subdirectory(doc)
endif()

# format
if(${FORMAT})
	include(clang_format)
endif()
