# build code as object library for easier linking to tests
add_library(${CMAKE_PROJECT_NAME}_obj OBJECT
	add.c
	subtract.c)

add_executable(${CMAKE_PROJECT_NAME}
	main.c
	$<TARGET_OBJECTS:${CMAKE_PROJECT_NAME}_obj>)
