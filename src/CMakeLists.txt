# build code as object library for easier linking to tests
add_library(c_template OBJECT
	functions.c)

# add main executable
add_executable(main
	main.c
	$<TARGET_OBJECTS:c_template>)
