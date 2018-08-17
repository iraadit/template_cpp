# add c header which contains project info
configure_file(
	"${PROJECT_SOURCE_DIR}/cmake/version.h.in"
	"${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/version.h")
