CWD = $(shell pwd)

POM = -f pom.xml
# Maven Clean Install Skip ; skip tests, javadoc, scaladoc, etc
MS = mvn -DskipTests -Dmaven.javadoc.skip=true -Dskip
MCIS = $(MS) clean install
MCCS = $(MS) clean compile

VER = $(error specify VER=releasefile-name e.g. VER=1.9.7-rc2)
loud = echo "@@" $(1);$(1)

# Source: https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
.PHONY: help

.ONESHELL:
help:   ## Show these help instructions
	@sed -rn 's/^([a-z0-9_\/\.-]+):[^#]*## (.*)$$/"\1" "\2"/p' < $(MAKEFILE_LIST) | xargs printf "make %-20s# %s\n"

target: ## mkdir target
	mkdir target

target/opendata.hessen.de.ttl: | target ## download
	rpt integrate -e remote --loc https://sparql.opendata.hessen.de/odp-hessen/ spo.rq --out-file target/opendata.hessen.de.ttl

target/stage01.trig: | target/opendata.hessen.de.ttl ## select frankfurt
	rpt integrate target/opendata.hessen.de.ttl 01-geolocation.rq gspo.rq --out-file target/stage01.trig

target/stage02.ttl: target/opendata.hessen.de.ttl ## fetch metadata
	rpt integrate target/opendata.hessen.de.ttl 02-fetch-catalog-metadata.rq --out-file target/stage02.ttl
	#rpt integrate  -e remote --loc https://sparql.opendata.hessen.de/odp-hessen/ 02-fetch-catalog-metadata.rq --out-file target/stage02.ttl

target/stage03.ttl: target/stage02.ttl ## delete dct:modified
	rpt integrate target/stage02.ttl 03-delete-dct-modified.ru spo.rq --out-file target/stage03.ttl

target/stage99.ttl: | target/stage01.trig target/stage03.ttl ## merge and flatten
	rpt integrate target/stage01.trig target/stage03.ttl 'CONSTRUCT { ?s ?p ?o } { { ?s ?p ?o } UNION { GRAPH ?g { ?s ?p ?o } } }' --out-file target/stage99.ttl

