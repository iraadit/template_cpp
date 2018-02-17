# add test executable
add_executable(test_inheritance
	inheritance.cpp
	$<TARGET_OBJECTS:test_obj>
	$<TARGET_OBJECTS:inheritance_obj>)

# add executable to test list
add_test(inheritance test_inheritance)
