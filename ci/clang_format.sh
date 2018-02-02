#!/bin/bash

set -e
shopt -s globstar
shopt -s nullglob

xml="$(clang-format -output-replacements-xml -style=file \
	{src,include,test}/**/*.{c,h,cpp,hpp})"

# do not fail when no replacements
set +e
replacements="$(echo "$xml" | grep -cv \
	-e "^<?xml version='1.0'?>\$" \
	-e "^<replacements xml:space='preserve' incomplete_format='false'>\$" \
	-e "^</replacements>\$")"

case $? in
0)
	printf '%i replacement(s)\n' "$replacements"
	printf '%s\n' "$xml"
	exit 1
	;;
1)
	exit 0
	;;
*)
	printf 'internal error\n'
	exit 2
	;;
esac
