add_library(${CMAKE_PROJECT_NAME}_obj OBJECT
	derived.cpp)

add_executable(${CMAKE_PROJECT_NAME}
	main.cpp
	$<TARGET_OBJECTS:${CMAKE_PROJECT_NAME}_obj>)
