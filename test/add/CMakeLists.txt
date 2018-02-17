# add test executable
add_executable(test_add
	add.cpp
	$<TARGET_OBJECTS:test_obj>
	$<TARGET_OBJECTS:c_template_obj>)

# add executable to test list
add_test(add test_add)
