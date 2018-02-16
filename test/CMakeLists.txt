# include catch framework
include_directories(SYSTEM "${CATCH_INCLUDE_DIR}")

# compile main as object library for usage in tests
add_library(test_obj OBJECT
	main.cpp)

# add test subdirectories
add_subdirectory(add)
