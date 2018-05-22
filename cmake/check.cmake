# add check target as a convience target to invoke all checks
add_custom_target(check)

if(${LINE_LIMIT})
	add_dependencies(check line_limit)
endif()

if(${REGEX_CHECK})
	add_dependencies(check regex_check)
endif()

if(${FLAWFINDER})
	add_dependencies(check flawfinder)
endif()

if(${FORMAT})
	add_dependencies(check format_check)
endif()
