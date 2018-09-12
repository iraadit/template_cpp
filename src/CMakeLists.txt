# build code as object library for easier linking to tests
add_library(${PROJECT_NAME}_obj OBJECT
	add.c
	subtract.c)

add_executable(${PROJECT_NAME}
	main.c
	$<TARGET_OBJECTS:${PROJECT_NAME}_obj>)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
