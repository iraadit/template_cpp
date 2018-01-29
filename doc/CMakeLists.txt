# find doxygen prereqs
find_package(Doxygen REQUIRED)

set(DOXYDIR ${CMAKE_BINARY_DIR}/doxygen)
set(DOXYFILE ${DOXYDIR}/Doxyfile)
set(DOXY_TARGET_NAME "_xml_doxygen")

set(DOXY_BUILD_HTML "YES")
set(DOXY_BUILD_XML "YES")
set(DOXY_BUILD_LATEX "NO")
set(DOXY_WARN_AS_ERR "NO")

# if doxygen is speficied only doxygen html output is generated.
# This also enables warning as erros to verify complete doxygen
# coverage.
if(DOC MATCHES "doxygen")
	set(DOXY_TARGET_NAME "doc")
	set(DOXY_BUILD_HTML "YES")
	set(DOXY_BUILD_XML "NO")
	set(DOXY_BUILD_LATEX "NO")
	set(DOXY_WARN_AS_ERR "YES")
endif()


configure_file(
	"${CMAKE_SOURCE_DIR}/doc/Doxyfile.in"
	"${DOXYFILE}"
	@ONLY
)

add_custom_target(
	${DOXY_TARGET_NAME}
	COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE}
	WORKING_DIRECTORY ${DOXYDIR}
	COMMENT "Generating API documentation with DoxyGen"
)


if(NOT DOC MATCHES "doxygen")
	include(find_python_module)
	find_package(PythonInterp REQUIRED)
	find_python_module(sphinx REQUIRED)
	find_python_module(breathe REQUIRED)

	set(DOC_TMP_DIR ${CMAKE_BINARY_DIR}/tmp)

	file(WRITE ${DOC_TMP_DIR}/copy_doc.cmake
		"file( COPY ${CMAKE_SOURCE_DIR}/doc DESTINATION ${DOC_TMP_DIR})")

	configure_file(
		"${CMAKE_SOURCE_DIR}/doc/conf.py.in"
		"${CMAKE_BINARY_DIR}/doc/conf.py"
		@ONLY
	)

	add_custom_target(_copy_doc
		COMMAND ${CMAKE_COMMAND} -P "${DOC_TMP_DIR}/copy_doc.cmake"
		DEPENDS ${DOXY_TARGET_NAME}
		COMMENT "Copying doc to build for postprocessing."
	)

	add_custom_target(_postprocess_doc
		COMMAND ${PYTHON_EXECUTABLE} "${CMAKE_SOURCE_DIR}/cmake/apidoc.py"
		-f -i -g group,struct,union,namespace,file,interface,class
		-o "${DOC_TMP_DIR}/doc/api"
		"${DOXYDIR}/xml"
		DEPENDS _copy_doc
		COMMENT "Generating rst from doxygen xml."
	)

	add_custom_target(doc
		COMMAND ${PYTHON_EXECUTABLE} -msphinx -M ${DOC}
		"${DOC_TMP_DIR}/doc" "${CMAKE_BINARY_DIR}/doc"
		-c "${CMAKE_BINARY_DIR}/doc"
		DEPENDS _postprocess_doc
		COMMENT "Generating sphinx ${DOC} documentation."
	)

	unset(doc_dir)

endif()

unset(DOXYDIR)
unset(DOXYFILE)
unset(DOXY_TARGET_NAME)
unset(DOXY_BUILD_HTML)
unset(DOXY_BUILD_XML)
unset(DOXY_BUILD_LATEX)
unset(DOXY_WARN_AS_ERR)
