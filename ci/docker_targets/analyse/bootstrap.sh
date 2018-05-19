#!/bin/sh

set -e

apk --no-cache add \
	bash \
	cmake \
	coreutils \
	coreutils \
	findutils \
	grep \
	make \
	openssh-client \
	rsync \
	sed
