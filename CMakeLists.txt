# 3.1.3 required for CMAKE_C_STANDARD
cmake_minimum_required(VERSION 3.1.3 FATAL_ERROR)

# set build type to release if none is specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
	set(CMAKE_BUILD_TYPE Release CACHE STRING
		"Choose the type of build." FORCE)
	set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
		"Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# disable building tests if not specified
if(NOT DEFINED BUILD_TESTING)
	set(BUILD_TESTING OFF CACHE BOOL "Build tests.")
endif()

# set base language
set(PROJECT_LANGUAGES C)

# enable c++ if building tests
if(BUILD_TESTING)
	set(CXX_REQUIRED ON)
	set(PROJECT_LANGUAGES ${PROJECT_LANGUAGES} CXX)
else()
	unset(CXX_REQUIRED)
endif()

# declare project
project(c_template VERSION 0.0.0 LANGUAGES ${PROJECT_LANGUAGES})

# abort if compilers differ
if(CXX_REQUIRED AND (NOT CMAKE_C_COMPILER_ID STREQUAL CMAKE_CXX_COMPILER_ID))
	message(FATAL_ERROR "c and c++ compillers differ")
endif()

# set standards to c11 and c++14, disable extensions
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# set warning flags for clang and gcc
# gcc source https://gcc.gnu.org/onlinedocs/gcc-6.1.0/gcc/Warning-Options.html
if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
	add_compile_options(-Werror -Weverything -Wno-switch-enum)
elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU")
	add_compile_options(-Werror -Wpedantic -Wall -Wextra
		-Wdouble-promotion
		-Wformat=2
		-Winit-self
		-Wmain
		-Wmissing-include-dirs
		-Wswitch-default
		-Wuninitialized
		-Wstrict-aliasing
		-Wsuggest-final-types
		-Wsuggest-final-methods
		-Wtrampolines
		-Wfloat-equal
		-Wundef
		-Wshadow
		-Wunsafe-loop-optimizations
		-Wcast-qual
		-Wcast-align
		-Wwrite-strings
		-Wconversion
		-Wsign-conversion
		-Wdate-time
		-Wlogical-op
		-Waggregate-return
		-Wmissing-declarations
		-Wnormalized
		-Wpacked
		-Wredundant-decls
		-Winline
		-Winvalid-pch
		-Wlong-long
		-Wstack-protector)

	# some flags only supported by GCC >= 6
	if(NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "6.0.0")
		add_compile_options(-Wnull-dereference
			-Wshift-overflow=2
			-Wduplicated-cond
			-Whsa)
	endif()

	# set c specific flags manually
	set(C_FLAGS_EXTRA
		"-Wtraditional-conversion \
		-Wbad-function-cast \
		-Wjump-misses-init \
		-Wstrict-prototypes \
		-Wold-style-definition \
		-Wmissing-prototypes \
		-Wnested-externs")
	set(CMAKE_C_FLAGS_DEBUG
		"${CMAKE_C_FLAGS_DEBUG} ${C_FLAGS_EXTRA}")
	set(CMAKE_C_FLAGS_RELEASE
		"${CMAKE_C_FLAGS_RELEASE} ${C_FLAGS_EXTRA}")
	set(CMAKE_C_FLAGS_RELWITHDEBINFO
		"${CMAKE_C_FLAGS_RELWITHDEBINFO} ${C_FLAGS_EXTRA}")
	set(CMAKE_C_FLAGS_MINSIZEREL
		"${CMAKE_C_FLAGS_MINSIZEREL} ${C_FLAGS_EXTRA}")

	# set c++ specific flags manually
	set(CXX_FLAGS_EXTRA
		"-Wconditionally-supported \
		-Wzero-as-null-pointer-constant \
		-Wuseless-cast")
	set(CMAKE_CXX_FLAGS_DEBUG
		"${CMAKE_CXX_FLAGS_DEBUG} ${CXX_FLAGS_EXTRA}")
	set(CMAKE_CXX_FLAGS_RELEASE
		"${CMAKE_CXX_FLAGS_RELEASE} ${CXX_FLAGS_EXTRA}")
	set(CMAKE_CXX_FLAGS_RELWITHDEBINFO
		"${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${CXX_FLAGS_EXTRA}")
	set(CMAKE_CXX_FLAGS_MINSIZEREL
		"${CMAKE_CXX_FLAGS_MINSIZEREL} ${CXX_FLAGS_EXTRA}")
else()
	message(WARNING "warning flags not supported for current compiler")
endif()

# add include directory
include_directories(include)

# add src directory
add_subdirectory(src)

# add test directory
if(BUILD_TESTING)
	enable_testing()
	add_subdirectory(test)
endif()
