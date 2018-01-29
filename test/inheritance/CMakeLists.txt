# add test executable
add_executable(test_inheritance
	inheritance.cpp
	$<TARGET_OBJECTS:test_main>
	$<TARGET_OBJECTS:inheritance>)

# add executable to test list
add_test(inheritance test_inheritance)
