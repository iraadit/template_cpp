# find plantuml
find_program(PLANTUML_PATH
	NAMES plantuml
	DOC "Path to PlantUML wrapper script.")

if(NOT PLANTUML_PATH)
	message(FATAL_ERROR "Could not find PlantUML.")
endif()
message(STATUS "Found PlantUML: ${PLANTUML_PATH}")
