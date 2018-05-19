add_custom_target(line_limit
	COMMENT "Running line_limit checks"
	COMMAND ./ci/style/line_limit.sh
		-e "'\\.(c|cpp|h|hpp)$$'"
		-e "'^\\.clang-tidy$$'"
		-e "'^cmake/apidoc\\.py$$'"
		-e "'^build.*/'"
		-i .
	COMMAND ./ci/style/line_limit.sh
		-e "'CMakeLists\\.txt$$'" include
	COMMAND ./ci/style/line_limit.sh
		-e "'CMakeLists\\.txt$$'" src
	COMMAND ./ci/style/line_limit.sh
		-e "'CMakeLists\\.txt$$'" test
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
