find_package(PythonInterp REQUIRED)

add_custom_target(
	doc
	COMMAND ${PYTHON_EXECUTABLE} -msphinx -M ${DOC}
	"${CMAKE_SOURCE_DIR}/doc" "${CMAKE_BINARY_DIR}/doc"
	COMMENT "Building sphinx ${DOC} documentation"
)