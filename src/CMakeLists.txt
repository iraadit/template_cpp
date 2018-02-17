# build code as object library for easier linking to tests
add_library(cpp_template_obj OBJECT
	derived.cpp)

# add main executable
add_executable(cpp_template
	main.cpp
	$<TARGET_OBJECTS:cpp_template_obj>)
