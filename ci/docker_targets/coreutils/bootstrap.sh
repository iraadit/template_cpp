#!/bin/sh

set -e

apk --no-cache add \
	bash \
	coreutils \
	findutils \
	grep \
	openssh-client \
	rsync \
	sed
