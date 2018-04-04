# sanitise is not valid when it is not a debug build
if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
	message(FATAL_ERROR
		"Sanitise is only supported for CMAKE_BUILD_TYPE=DEBUG.")
endif()

# coverage and sanitise are mutually exclusive
if(${COVERAGE})
	message(FATAL_ERROR "COVERAGE and SANITISE are mutually exclusive.")
endif()

add_compile_options(-fno-sanitize-recover=all)
foreach(flag -fsanitize=address -fsanitize=undefined)
	add_compile_options("${flag}")
	if(NOT CMAKE_EXE_LINKER_FLAGS MATCHES "(^| +)${flag}($| +)")
		set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${flag}"
			CACHE STRING
			"Flags used by the linker during all build types."
			FORCE)
	endif()
endforeach(flag)
