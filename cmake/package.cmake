set(PKG_SRC "${PROJECT_SOURCE_DIR}/cmake/pkg")
set(PKG_TMP "${PROJECT_BINARY_DIR}/tmp/pkg")

configure_file(
	"${PKG_SRC}/${PROJECT_NAME}.desktop.in"
	"${PKG_TMP}/${PROJECT_NAME}.desktop"
	@ONLY)

install(
	FILES "${PKG_TMP}/${PROJECT_NAME}.desktop"
	DESTINATION share/applications)
