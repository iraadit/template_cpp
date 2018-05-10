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

	include(find_python_module)
	find_package(PythonInterp REQUIRED)
	find_python_module(breathe REQUIRED)
	find_python_module(sphinx REQUIRED)

	if($ENV{PYTHONPATH})
		set(ENV{PYTHONPATH}
			"${PY_breathe}:${PY_sphinx}:$ENV{PYTHONPATH}")
	else()
		set(ENV{PYTHONPATH} "${PY_breathe}:${PY_sphinx}")
	endif()

	if(${WERROR})
		set(SPHINX_WERROR "-W")
	else()
		unset(SPHINX_WERROR)
	endif()

	# https://git.mel.vin/template/c/issues/76
	#include(breathe_apidoc)
	set(BREATHE_APIDOC_PATH "${CMAKE_SOURCE_DIR}/cmake/apidoc.py")

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
		COMMAND "${PYTHON_EXECUTABLE}" "${BREATHE_APIDOC_PATH}"
			-o "${DOC_TMP}/api/file" -f -g file -q
			"${DOC_TMP}/doxygen/xml"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Converting Doxygen XML to RST by element type"
		COMMAND "${PYTHON_EXECUTABLE}" "${BREATHE_APIDOC_PATH}"
			-o "${DOC_TMP}/api/type" -f
			-g class,interface,struct,union,namespace,group -q
			"${DOC_TMP}/doxygen/xml"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Generating sphinx ${DOC} API by source file"
		COMMAND "${PYTHON_EXECUTABLE}" -m sphinx -b "${DOC}"
			-c "${DOC_TMP}/sphinx" -q ${SPHINX_WERROR}
			"${DOC_TMP}/api/file" "${DOC_DEST}/api/file"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Generating sphinx ${DOC} API by element type"
		COMMAND "${PYTHON_EXECUTABLE}" -m sphinx -b "${DOC}"
			-c "${DOC_TMP}/sphinx" -q ${SPHINX_WERROR}
			"${DOC_TMP}/api/type" "${DOC_DEST}/api/type"

		COMMAND "${CMAKE_COMMAND}" -E echo
			"Generating sphinx ${DOC} documentation"
		COMMAND "${PYTHON_EXECUTABLE}" -m sphinx -b "${DOC}"
			-c "${DOC_TMP}/sphinx" -q ${SPHINX_WERROR}
			"${DOC_SRC}" "${DOC_DEST}")

	add_custom_command(TARGET doc POST_BUILD
		COMMAND ;
		COMMENT "Output at ${DOC_DEST}")
endif()

