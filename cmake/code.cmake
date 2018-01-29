# create compilation database
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# set standards to c11 and c++17
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# set warning flags for debug
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	if(CMAKE_C_COMPILER_ID STREQUAL "Clang" OR
		CMAKE_C_COMPILER_ID STREQUAL "GNU")
		add_compile_options(-Wall -Wextra -Wconversion)
		if(WERROR)
			add_compile_options(-Werror)
		endif()
	else()
		message(WARNING "warnings not supported for current compiler")
	endif()
endif()

# add include directory
include_directories(BEFORE include)

# add coverage instrumentation
if(${COVERAGE})
	include(coverage)
endif()

# clang-tidy
if(${CLANG_TIDY})
	include(clang_tidy)
endif()

# add src directory
add_subdirectory(src)

# add test directory
if(${TEST})
	enable_testing()
	include(catch)
	add_subdirectory(test)
endif()
