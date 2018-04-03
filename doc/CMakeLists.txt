# find doxygen prereqs
find_package(Doxygen REQUIRED COMPONENTS dot)

message(status "dot path: ${DOXYGEN_DOT_EXECUTABLE}")

# due to a bug in doxygen HTML has to be enabled for xml to work
set(DOXY_BUILD_HTML "YES")
set(DOXY_BUILD_XML "YES")
set(DOXY_BUILD_LATEX "NO")
set(DOXY_WARN_AS_ERR "NO")

# if doxygen is specified only doxygen html output is generated.
# This also supports warning as errors to verify complete doxygen coverage
if(${DOC} STREQUAL "doxygen")
	set(DOXY_TARGET_NAME "doc")
	set(DOXY_BUILD_HTML "YES")
	set(DOXY_BUILD_XML "NO")
	set(DOXY_BUILD_LATEX "NO")
	if (${WERROR})
		set(DOXY_WARN_AS_ERR "YES")
	else()
		set(DOXY_WARN_AS_ERR "NO")
	endif()
endif()

set(DOC_DIR "${CMAKE_BINARY_DIR}/doc")
set(DOXYDIR "${DOC_DIR}/doxygen")
set(DOXYFILE "${DOXYDIR}/doxyfile")

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
	include(plantuml)

	if(${WERROR})
		set(SPHINX_WERROR "-W")
	else()
		unset(SPHINX_WERROR)
	endif()

	set(DOC_TMP_DIR "${DOC_DIR}/tmp")
	set(API_TMP_DIR "${DOC_TMP_DIR}/api")
	set(RST_TMP_DIR "${DOC_TMP_DIR}/rst")
	SET(SHPINX_BASE_DIR "${DOC_DIR}/sphinx")
	set(RST_INPUT_DIRS "\"${API_TMP_DIR}\",\"${CMAKE_SOURCE_DIR}/doc\"")
	set(SPHINX_OUTPUT_DIR "${SHPINX_BASE_DIR}/${DOC}")
	set(
		SPHINX_BUILD_RUNNER 
		"${SHPINX_BASE_DIR}/sphinx_multibuild_runner.py")

	configure_file(
		"${CMAKE_SOURCE_DIR}/doc/conf.py.in"
		"${SHPINX_BASE_DIR}/conf.py"
		@ONLY)

	configure_file(
		"${CMAKE_SOURCE_DIR}/cmake/sphinx_multibuild.py" 
		"${SHPINX_BASE_DIR}/sphinx_multibuild.py"
		COPYONLY)

	configure_file(
		"${CMAKE_SOURCE_DIR}/doc/sphinx_multibuild_runner.py.in"
		"${SPHINX_BUILD_RUNNER}"
		@ONLY)

	add_custom_target(doc
		# generate doxygen xml
		COMMAND ${DOXYGEN_EXECUTABLE} "${DOXYFILE}"

		# convert doxygen xml to rst files
		COMMAND ${PYTHON_EXECUTABLE}
			"${CMAKE_SOURCE_DIR}/cmake/apidoc.py" -f -i -q
			-g group,struct,union,namespace,file,interface,class
			-o "${API_TMP_DIR}/_api"
			"${DOXYDIR}/xml"

		# build sphinx documentation
		COMMAND ${PYTHON_EXECUTABLE} "${SPHINX_BUILD_RUNNER}"
		COMMENT "Generating sphinx ${DOC} documentation.")

	if(NOT ${DOC} STREQUAL "help")
		add_custom_command(TARGET doc POST_BUILD
			COMMAND ;
			COMMENT "Sphinx ${DOC} documentation is available \
at ${DOC_DIR}/sphinx/${sphinx_output}")
	endif()
endif()

