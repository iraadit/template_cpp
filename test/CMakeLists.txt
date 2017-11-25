# include catch framework
include_directories(catch/include)

# compile main as object library for usage in tests
add_library(test_main OBJECT
	main.cpp)

# add test subdirectories
add_subdirectory(functions)
