# some warnings trigger on the catch framework, so disable them
# other warnings not disabled to test code is also checked
if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
	add_compile_options(-Wno-exit-time-destructors)
elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU")
	add_compile_options(-Wno-aggregate-return)
endif()

# include catch framework
include_directories(catch/include)

# compile main as object library for usage in tests
add_library(test_main OBJECT main.cpp)

# add test subdirectories
add_subdirectory(functions)
