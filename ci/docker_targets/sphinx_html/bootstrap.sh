#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	doxygen \
	graphviz \
	libc-dev \
	make \
	py2-pip

pip install \
	breathe \
	sphinx \
	sphinx_rtd_theme
