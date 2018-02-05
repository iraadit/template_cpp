#!/bin/sh

set -e

apk --no-cache add \
	binutils \
	cmake \
	doxygen \
	graphviz \
	libc-dev \
	make \
	openjdk8-jre \
	py2-pip \
	ttf-liberation

apk --no-cache add -t tmp \
	curl

pip install \
	breathe \
	sphinx \
	sphinx_rtd_theme \
	sphinxcontrib-plantuml

mkdir -p /opt/plantuml
curl -Lf \
	-o /opt/plantuml/plantuml.jar \
	https://git.mel.vin/mirror/plantuml/raw/1.2018.1/plantuml.jar

printf '%s\n%s\n' \
	'#!/bin/sh' \
	'exec java -jar /opt/plantuml/plantuml.jar "$@"' \
	> /usr/local/bin/plantuml
chmod +x /usr/local/bin/plantuml

apk --no-cache del tmp
