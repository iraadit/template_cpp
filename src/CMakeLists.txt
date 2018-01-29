# build code as object library for easier linking to tests
add_library(c_template OBJECT
	add.c
	subtract.c)

# add main executable
add_executable(main
	main.c
	$<TARGET_OBJECTS:c_template>)

# add subdirectories
add_subdirectory(inheritance)
