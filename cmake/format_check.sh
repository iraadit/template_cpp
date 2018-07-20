#!/bin/bash

# intermediate script to support extra options for clang_format.sh

# current script dir
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# support WERROR option
[[ $WERROR == "ON" ]] && set -e

# call clang_format.sh to check repo
"$SCRIPT_DIR/../cicd/style/clang_format.sh" check "$1"

exit 0
