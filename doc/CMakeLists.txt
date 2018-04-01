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
	find_python_module(breathe REQUIRED)
	include(plantuml)

	set(DOC_TMP_DIR "${DOC_DIR}/tmp")

	# Determine whether to use autobuild or normal build.
	if("${DOC}" MATCHES "^auto")
		include(sphinx-autobuild)
		set(sphinx_output ${DOC})
		STRING(REGEX REPLACE "^auto" "" sphinx_output ${DOC})
		set(sphinx_cmd 
			${PYTHON_EXECUTABLE}
			"${CMAKE_SOURCE_DIR}/cmake/autosymlink.py"
			"-m" "-q"
			"${CMAKE_SOURCE_DIR}/doc" "${DOC_TMP_DIR}" &
			"${SPHINXAUTOBUILD_PATH}")
	else()
		include(sphinx-build)
		set(sphinx_output "${DOC}")
		set(sphinx_cmd 
			${PYTHON_EXECUTABLE}
			"${CMAKE_SOURCE_DIR}/cmake/autosymlink.py" "-q"
			"${CMAKE_SOURCE_DIR}/doc" "${DOC_TMP_DIR}" &&
			"${SPHINXBUILD_PATH}")
	endif()

	# support WERROR for sphinx
	if(${WERROR})
		set(SPHINX_WERROR "-W")
	else()
		unset(SPHINX_WERROR)
	endif()

	configure_file(
		"${CMAKE_SOURCE_DIR}/doc/conf.py.in"
		"${DOC_DIR}/sphinx/conf.py"
		@ONLY)

	add_custom_target(doc
		# generate doxygen xml
		COMMAND ${DOXYGEN_EXECUTABLE} "${DOXYFILE}"

		# convert doxygen xml to rst files
		COMMAND ${PYTHON_EXECUTABLE}
			"${CMAKE_SOURCE_DIR}/cmake/apidoc.py" -f -i -q
			-g group,struct,union,namespace,file,interface,class
			-o "${DOC_TMP_DIR}/_api"
			"${DOXYDIR}/xml"

		# build sphinx documentation
		COMMAND ${sphinx_cmd} -b ${sphinx_output}
			"${DOC_TMP_DIR}" "${DOC_DIR}/sphinx/${sphinx_output}"
			-c "${DOC_DIR}/sphinx" -q ${SPHINX_WERROR}
		COMMENT "Generating sphinx ${DOC} documentation.")

	if(NOT ${DOC} STREQUAL "help")
		add_custom_command(TARGET doc POST_BUILD
			COMMAND ;
			COMMENT "Sphinx ${DOC} documentation is available \
at ${DOC_DIR}/sphinx/${sphinx_output}")
	endif()
endif()

