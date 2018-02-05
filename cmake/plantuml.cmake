# find plantuml
find_program(PLANTUML_PATH
	NAMES plantuml
	DOC "Path to plantuml.")

if(NOT PLANTUML_PATH)
	message(FATAL_ERROR "Could not find plantuml.")
endif()
message(STATUS "Found plantuml: ${PLANTUML_PATH}")
