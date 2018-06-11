#!/bin/bash

# intermediate script to support extra options for line_limit.sh

# current script dir
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# support WERROR option
[[ $WERROR == "ON" ]] && set -e

# call line_limit.sh to check repo
"$SCRIPT_DIR/../cicd/style/line_limit.sh" \
	-e '\.(c|cpp|h|hpp)$' \
	-e '^\.clang-tidy$' \
	-e '^build[^/]*/' \
	-i "$SCRIPT_DIR/.."
"$SCRIPT_DIR/../cicd/style/line_limit.sh" \
	-e 'CMakeLists\.txt$' \
	"$SCRIPT_DIR/../include"
"$SCRIPT_DIR/../cicd/style/line_limit.sh" \
	-e 'CMakeLists\.txt$' \
	"$SCRIPT_DIR/../src"
"$SCRIPT_DIR/../cicd/style/line_limit.sh" \
	-e 'CMakeLists\.txt$' \
	"$SCRIPT_DIR/../test"

exit 0
