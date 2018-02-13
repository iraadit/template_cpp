#!/bin/bash

set -e
shopt -s globstar
shopt -s nullglob

case "$1" in
'check')
	;;
'format')
	;;
*)
	printf '%s\n' \
"usage: $0 [check|format]
	always call from root of repo

	check
		check sources and report replacements

	format
		format sources in place

	EXIT CODE
		0	[check] no replacements
			[format] completed ok
		1	[check] found replacements
		2	internal error
		*	when any commands fails because of 'set -e'"
	exit 2
	;;
esac

targets=({src,include,test}/**/*.{c,h,cpp,hpp})

# run format if requested
if [[ $1 == 'format' ]]
then
	clang-format -i -style=file "${targets[@]}"
	exit 0
fi

# checking logic otherwise
xml="$(clang-format -output-replacements-xml -style=file "${targets[@]}")"

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
