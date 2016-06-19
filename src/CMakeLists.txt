add_library(c_template OBJECT
	functions.c)

add_executable(main
	main.c
	$<TARGET_OBJECTS:c_template>)
