# find doxygen prereqs
find_package(Doxygen REQUIRED COMPONENTS dot)

set(DOXYDIR ${CMAKE_BINARY_DIR}/doxygen)
set(DOXYFILE ${DOXYDIR}/Doxyfile)
# due to a bug in doxygen HTML has to be enabled for xml to work
set(DOXY_BUILD_HTML "YES")
set(DOXY_BUILD_XML "YES")
set(DOXY_BUILD_LATEX "NO")
set(DOXY_WARN_AS_ERR "NO")

# if doxygen is specified only doxygen html output is generated.
# This also enables warning as errors to verify complete doxygen
# coverage
if(${DOC} STREQUAL "doxygen")
	set(DOXY_TARGET_NAME "doc")
	set(DOXY_BUILD_HTML "YES")
	set(DOXY_BUILD_XML "NO")
	set(DOXY_BUILD_LATEX "NO")
	set(DOXY_WARN_AS_ERR "YES")
else()
	# plantuml only required for non-doxygen targets
	include(plantuml)
endif()

configure_file(
	"${CMAKE_SOURCE_DIR}/doc/Doxyfile.in"
	"${DOXYFILE}"
	@ONLY)

if(${DOC} STREQUAL "doxygen")
	add_custom_target(
		doc
		COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE}
		COMMENT "Generating API documentation with DoxyGen")

	# show info where to find the report
	add_custom_command(TARGET doc POST_BUILD
		COMMAND ;
		COMMENT "Doxygen HTML documentation is available \
at ${DOXYDIR}/html/index.html")
else()
	include(find_python_module)
	find_package(PythonInterp REQUIRED)
	find_python_module(sphinx REQUIRED)
	find_python_module(breathe REQUIRED)

	# support WERROR for sphinx
	if(${WERROR})
		set(SPHINX_WERROR "-W")
	else()
		unset(SPHINX_WERROR)
	endif()

	set(DOC_TMP_DIR ${CMAKE_BINARY_DIR}/tmp)

	file(WRITE ${DOC_TMP_DIR}/copy_doc.cmake
		"file(COPY ${CMAKE_SOURCE_DIR}/doc DESTINATION ${DOC_TMP_DIR})")

	configure_file(
		"${CMAKE_SOURCE_DIR}/doc/conf.py.in"
		"${CMAKE_BINARY_DIR}/doc/conf.py"
		@ONLY)

	add_custom_target(doc
		# generate doxygen xml
		COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE}

		# copy src doc to tmp director
		COMMAND ${CMAKE_COMMAND} -P "${DOC_TMP_DIR}/copy_doc.cmake"

		# convert doxygen xml to rst files
		COMMAND ${PYTHON_EXECUTABLE}
			"${CMAKE_SOURCE_DIR}/cmake/apidoc.py" -f -i -q
			-g group,struct,union,namespace,file,interface,class
			-o "${DOC_TMP_DIR}/doc/api"
			"${DOXYDIR}/xml"

		# build sphinx documentation
		COMMAND ${PYTHON_EXECUTABLE} -msphinx -M ${DOC}
			"${DOC_TMP_DIR}/doc" "${CMAKE_BINARY_DIR}/doc"
			-c "${CMAKE_BINARY_DIR}/doc" -q ${SPHINX_WERROR}
		COMMENT "Generating sphinx ${DOC} documentation.")

	if(NOT ${DOC} STREQUAL "help")
		add_custom_command(TARGET doc POST_BUILD
			COMMAND ;
			COMMENT "Sphinx ${DOC} documentation is available \
at ${CMAKE_BINARY_DIR}/doc/html/index.html")
			endif()
endif()
