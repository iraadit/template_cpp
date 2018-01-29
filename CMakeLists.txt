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
option(WERROR "Make all warnings into errors." OFF)
option(COVERAGE "Instrument code with coverage flags." OFF)

# disable building tests if not specified
if(NOT DEFINED TEST)
	set(TEST OFF CACHE BOOL "Build tests.")
endif()

# set base language
set(PROJECT_LANGUAGES C)

# enable c++ if building tests
if(TEST)
	set(PROJECT_LANGUAGES ${PROJECT_LANGUAGES} CXX)
endif()

# declare project
project(c_template VERSION 1.2.0 LANGUAGES ${PROJECT_LANGUAGES})

# set standards to c11 and c++17
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# set warning flags
if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
	message(STATUS "compiler warning flags not enabled for release")
elseif(CMAKE_C_COMPILER_ID STREQUAL "Clang" OR
		CMAKE_C_COMPILER_ID STREQUAL "GNU")
	add_compile_options(-Wall -Wextra -Wconversion)
	if(WERROR)
		add_compile_options(-Werror)
	endif()
else()
	message(WARNING "warning flags not supported for current compiler")
endif()

# create compilation database
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# add include directory
include_directories(BEFORE include)

# add coverage instrumentation
if(COVERAGE)
	include(coverage)
endif()

# clang-tidy
if(CLANG_TIDY)
	include(clang_tidy)
endif()

# add src directory
add_subdirectory(src)

# add test directory
if(TEST)
	enable_testing()
	add_subdirectory(test)
endif()
