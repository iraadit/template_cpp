# build code as object library for easier linking to tests
add_library(c_template_obj OBJECT
	add.c
	subtract.c)

# add main executable
add_executable(c_template
	main.c
	$<TARGET_OBJECTS:c_template_obj>)

# add subdirectories
add_subdirectory(inheritance)
