# add test executable
add_executable(test_functions
	add.cpp
	$<TARGET_OBJECTS:test_main>
	$<TARGET_OBJECTS:c_template>)

# add executable to test list
add_test(inheritance test_functions)
