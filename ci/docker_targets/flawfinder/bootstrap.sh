#!/bin/sh

set -e

apk --no-cache add \
	cmake \
	make \
	py2-pip

pip install \
	flawfinder
