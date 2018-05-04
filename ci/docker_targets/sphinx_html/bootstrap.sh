#!/bin/sh

set -e

apk --no-cache add \
	cmake \
	doxygen \
	graphviz \
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
	sphinxcontrib-plantuml \
	sphinx-multibuild

mkdir -p /opt/plantuml
for i in batik-all-1.7.jar jlatexmath-minimal-1.0.3.jar jlm_cyrillic.jar \
	jlm_greek.jar plantuml.jar
do
	curl -Lf \
		-o /opt/plantuml/$i \
		https://git.mel.vin/mirror/plantuml/raw/1.2018.1/$i
done

printf '%s\n%s\n' \
	'#!/bin/sh' \
	'exec java -jar /opt/plantuml/plantuml.jar "$@"' \
	> /usr/local/bin/plantuml
chmod +x /usr/local/bin/plantuml

apk --no-cache del tmp
