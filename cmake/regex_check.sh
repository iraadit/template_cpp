#!/bin/bash

# intermediate script to support extra options for regex_check.sh

# current script dir
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# support WERROR option
[[ $WERROR == "ON" ]] && set -e

# call regex_check.sh to check repo
"$SCRIPT_DIR/../cicd/style/regex_check.sh" \
	-e '^build[^/]*/' \
	-e '^.*\.svg$' \
	"$SCRIPT_DIR/.."
"$SCRIPT_DIR/../cicd/style/regex_check.sh" \
	-e '^build[^/]*/' \
	-r '(^$)|(^.*[^[:cntrl:][:blank:]]$)' \
	"$SCRIPT_DIR/.."

exit 0
