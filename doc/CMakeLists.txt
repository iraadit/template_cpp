# find prereqs
find_package(PythonInterp REQUIRED)
find_package(Doxygen REQUIRED)

include(find_python_module)

find_python_module(sphinx REQUIRED)
find_python_module(breathe REQUIRED)

set(doc_dir ${CMAKE_BINARY_DIR}/tmp)
set(doxydir ${CMAKE_BINARY_DIR}/doxygen)
set(doxyfile ${doxydir}/Doxyfile)

file(WRITE ${CMAKE_BINARY_DIR}/copy_doc.cmake
	"file( COPY ${CMAKE_SOURCE_DIR}/doc DESTINATION ${doc_dir})")

configure_file(
	"${CMAKE_SOURCE_DIR}/doc/Doxyfile.in"
	"${doxyfile}"
	@ONLY
)

configure_file(
	"${CMAKE_SOURCE_DIR}/doc/conf.py.in"
	"${CMAKE_BINARY_DIR}/doc/conf.py"
	@ONLY
)

add_custom_target(
	_xml_doxygen
	COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
	WORKING_DIRECTORY ${doxydir}
	COMMENT "Generating API documentation with DoxyGen"
)

add_custom_target(_copy_doc
	COMMAND ${CMAKE_COMMAND} -P "${CMAKE_BINARY_DIR}/copy_doc.cmake"
	DEPENDS _xml_doxygen
	COMMENT "Copying doc to build for postprocessing."
)

add_custom_target(_postprocess_doc
	COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_SOURCE_DIR}/cmake/apidoc.py" -f -i
	-g group -g struct,union,namespace,file,interface,class
	-o "${doc_dir}/doc/api"
	"${doxydir}/xml"
	DEPENDS _copy_doc
	COMMENT "Generating rst from doxygen xml."
)

add_custom_target(
	doc
	COMMAND ${PYTHON_EXECUTABLE} -msphinx -M ${DOC}
	"${doc_dir}/doc" "${CMAKE_BINARY_DIR}/doc"
	-c "${CMAKE_BINARY_DIR}/doc"
	DEPENDS _postprocess_doc
	COMMENT "Generating sphinx ${DOC} documentation."
)

unset(doc_dir)
unset(doxydir)
unset(doxyfile)
