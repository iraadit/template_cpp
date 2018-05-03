#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	gcc \
	libc-dev \
	make \
	py2-pip

pip install \
	flawfinder
