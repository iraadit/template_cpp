#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	openjdk8-jre-base \
	doxygen \
	graphviz \
	libc-dev \
	make \
	py2-pip

pip install \
	breathe \
	sphinx \
	sphinx_rtd_theme \
	sphinxcontrib.plantuml
