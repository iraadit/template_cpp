#!/bin/sh

set -e

apk --no-cache add \
	bash \
	cmake \
	coreutils \
	findutils \
	git \
	grep \
	make \
	openssh-client \
	rsync \
	sed
