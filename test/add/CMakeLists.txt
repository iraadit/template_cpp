# add test executable
add_executable(test_add
	add.cpp
	$<TARGET_OBJECTS:test_main>
	$<TARGET_OBJECTS:c_template>)

# add executable to test list
add_test(add test_add)
