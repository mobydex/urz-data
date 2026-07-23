#!/usr/bin/env bash

ogr2ogr \
  -f CSV \
  /vsistdout/ \
  "$1" \
  ReferenzGebietsstand2021 \
  -s_srs "${2:-OGC:CRS84}" \
  -t_srs OGC:CRS84 \
  -lco GEOMETRY=AS_WKT \
  -lco GEOMETRY_NAME=geometry

