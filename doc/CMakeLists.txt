find_package(Doxygen REQUIRED COMPONENTS dot)

set(DOC_SRC "${CMAKE_SOURCE_DIR}/doc")
set(DOC_DEST "${CMAKE_BINARY_DIR}/doc/${DOC}")
set(DOC_TMP "${CMAKE_BINARY_DIR}/tmp/doc")

set(DOXY_BUILD_LATEX "NO")
if (${WERROR})
	set(DOXY_WARN_AS_ERR "YES")
else()
	set(DOXY_WARN_AS_ERR "NO")
endif()

# if the target is doxygen build only only doxygen HTML
if(${DOC} STREQUAL "doxygen")
	set(DOXY_BUILD_HTML "YES")
	set(DOXY_BUILD_XML "NO")
	set(DOXY_OUTPUT_DIR "${DOC_DEST}")
# otherwise generate only XML and configure sphinx
else()
	set(DOXY_BUILD_HTML "NO")
	set(DOXY_BUILD_XML "YES")
	set(DOXY_OUTPUT_DIR "${DOC_TMP}/doxygen")

	# https://git.mel.vin/template/c/issues/50
	# https://bugzilla.gnome.org/show_bug.cgi?id=792676
	set(DOXY_WARN_AS_ERR "NO")

	find_package(PythonInterp REQUIRED)
	include(find_python_module)
	find_python_module(breathe)
	find_python_module(sphinx)

	# do not change the ENV, doesn't work with add_custom_target
	# https://cmake.org/Bug/view.php?id=5145
	if(ENV{PYTHONPATH})
		set(PYTHONPATH
			"${BREATHE_PATH}:${SPHINX_PATH}:$ENV{PYTHONPATH}")
	else()
		# PYTHONPATH disables defaults, manually append them
		execute_process(COMMAND "${PYTHON_EXECUTABLE}" "-c"
		"import sys; sys.stdout.write(':'.join(sys.path))"
		OUTPUT_VARIABLE PYTHONPATH)
		set(PYTHONPATH "${BREATHE_PATH}:${SPHINX_PATH}:${PYTHONPATH}")
	endif()

	if(${WERROR})
		set(SPHINX_WERROR "-W")
	else()
		unset(SPHINX_WERROR)
	endif()

	include(breathe_apidoc)
	include(plantuml)

	configure_file(
		"${DOC_SRC}/conf.py.in"
		"${DOC_TMP}/sphinx/conf.py"
		@ONLY)
endif()

configure_file(
	"${DOC_SRC}/doxyfile.in"
	"${DOC_TMP}/doxygen/doxyfile"
	@ONLY)

if(${DOC} STREQUAL "doxygen")
	add_custom_target(doc
		COMMAND "${DOXYGEN_EXECUTABLE}" "${DOC_TMP}/doxygen/doxyfile"
		COMMENT "Generating HTML API documentation with Doxygen")

	add_custom_command(TARGET doc POST_BUILD
		COMMAND ;
		COMMENT "Output at ${DOC_DEST}/html/index.html")
else()
	configure_file("${DOC_SRC}/api/file/index.rst.in"
		"${DOC_TMP}/api/file/index.rst" @ONLY)
	configure_file("${DOC_SRC}/api/type/index.rst.in"
		"${DOC_TMP}/api/type/index.rst" @ONLY)

	add_custom_target(doc
		COMMAND "${CMAKE_COMMAND}" -E echo
			"Generating Doxygen XML API output"
		COMMAND "${DOXYGEN_EXECUTABLE}" "${DOC_TMP}/doxygen/doxyfile"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Converting Doxygen XML to RST by source file"
		COMMAND "${CMAKE_COMMAND}" -E env "PYTHONPATH=${PYTHONPATH}"
			"${PYTHON_EXECUTABLE}" "${BREATHE_APIDOC_PATH}"
			-o "${DOC_TMP}/api/file" -f -g file -q
			"${DOC_TMP}/doxygen/xml"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Converting Doxygen XML to RST by element type"
		COMMAND "${CMAKE_COMMAND}" -E env "PYTHONPATH=${PYTHONPATH}"
			"${PYTHON_EXECUTABLE}" "${BREATHE_APIDOC_PATH}"
			-o "${DOC_TMP}/api/type" -f
			-g class,interface,struct,union,namespace,group -q
			"${DOC_TMP}/doxygen/xml"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Generating sphinx ${DOC} API by source file"
		COMMAND "${CMAKE_COMMAND}" -E env "PYTHONPATH=${PYTHONPATH}"
			"${PYTHON_EXECUTABLE}" -m sphinx -b "${DOC}"
			-c "${DOC_TMP}/sphinx" -q ${SPHINX_WERROR}
			"${DOC_TMP}/api/file" "${DOC_DEST}/api/file"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Generating sphinx ${DOC} API by element type"
		COMMAND "${CMAKE_COMMAND}" -E env "PYTHONPATH=${PYTHONPATH}"
			"${PYTHON_EXECUTABLE}" -m sphinx -b "${DOC}"
			-c "${DOC_TMP}/sphinx" -q ${SPHINX_WERROR}
			"${DOC_TMP}/api/type" "${DOC_DEST}/api/type"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Generating sphinx ${DOC} documentation"
		COMMAND "${CMAKE_COMMAND}" -E env "PYTHONPATH=${PYTHONPATH}"
			"${PYTHON_EXECUTABLE}" -m sphinx -b "${DOC}"
			-c "${DOC_TMP}/sphinx" -q ${SPHINX_WERROR}
			"${DOC_SRC}" "${DOC_DEST}")

	add_custom_command(TARGET doc POST_BUILD
		COMMAND ;
		COMMENT "Output at ${DOC_DEST}")
endif()

