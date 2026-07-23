ogr2ogr \
  -f CSV \
  /vsistdout/ \
  "$1" \
  VG250_GEM \
  -t_srs OGC:CRS84 \
  -lco GEOMETRY=AS_WKT \
  -lco GEOMETRY_NAME=geometry

# -select OBJID,AGS_0,ARS_0,GEN,BEGINN \

