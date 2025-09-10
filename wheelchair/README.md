## Accessibility Data

### Trainstations + Wheelchair Accessibility

<img width="300" alt="image" src="https://github.com/user-attachments/assets/8b52fd7d-67a4-47f8-b1bc-7da9ea14cf83" />

* [YasGui Link](https://api.triplydb.com/s/DA90SQxJm)
* [GraphQL Link / GeoJSON](https://data.aksw.org/mobydex/graphql?qtxt=query+%40pretty+%40debug%0A++%40prefix%28map%3A+%7B%0A++++geo%3A+%22http%3A%2F%2Fwww.opengis.net%2Font%2Fgeosparql%23%22%2C%0A++++geof%3A+%22http%3A%2F%2Fwww.opengis.net%2Fdef%2Ffunction%2Fgeosparql%2F%22%2C%0A++++osmt%3A+%22https%3A%2F%2Fwww.openstreetmap.org%2Fwiki%2FKey%3A%22%2C%0A++++rdf%3A+%22http%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%22%2C%0A++++rdfs%3A+%22http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%22%2C%0A++++afn%3A+%22http%3A%2F%2Fjena.apache.org%2FARQ%2Ffunction%23%22%2C%0A++++o%3A+%22https%3A%2F%2Fschema.coypu.org%2Fglobal%23%22%2C%0A++++norse%3A+%22https%3A%2F%2Fw3id.org%2Faksw%2Fnorse%23%22%0A++%7D%29%0A%7B%0A++type+%40bind%28of%3A+%22%27FeatureCollection%27%22%29%0A++features%28%0A++++area%3A+%22POLYGON+%28%286.475457372470345+51.7037981703763%2C+6.475457372470346+51.2481032780451%2C+7.544268491722988+51.24810327804511%2C+7.544268491722988+51.70379817037631%2C+6.475457372470345+51.7037981703763%29%29%22%0A++++limit%3A+10%0A++%29%0A++++%40pattern%28of%3A+%22%3Fs+a+o%3ATrainStation%22%29%0A%0A++++%23+Ad-hoc+binding+of+the+argument+%27area%27+to+a+SPARQL+filter+expression.%0A++++%40filter%28when%3A+%22bound%28%3Farea%29+%26%26+%3Farea+%21%3D+%27%27%22%2C+by%3A+%22EXISTS+%7B+%3Fs+geo%3AhasGeometry%2Fgeo%3AasWKT+%3Fwkt+FILTER%28geof%3AsfIntersects%28strdt%28%3Farea%2C+geo%3AwktLiteral%29%2C+%3Fwkt%29%29+%7D%22%2C+this%3A+%22s%22%2C+parent%3A+%22s%22%29%0A++%7B%0A++++type+%40bind%28of%3A+%22%27Feature%27%22%29++++%0A++++properties+%7B%0A++++++type+%40rdf%28iri%3A+%22rdf%3Atype%22%29%0A++++++po+%40pattern%28of%3A+%22%3Fs+%3Fp+%3Fo+.+FILTER%28%3Fp+NOT+IN+%28rdf%3Atype%2C+geo%3Ageometry%29%29%22%29+%40index%28by%3A+%22afn%3Alocalname%28%3Fp%29%22%2C+oneIf%3A+%22true%22%29%0A++++%7D%0A++++geometry+%40one%0A++++++%40pattern%28of%3A+%22%22%22%0A++++++++%3Fs+geo%3AhasGeometry%2Fgeo%3AasWKT+%3Fx+.%0A++++++++BIND%28STRDT%28STR%28geof%3AasGeoJSON%28geof%3AsimplifyDp%28%3Fx%2C+0.2%29%29%29%2C+norse%3Ajson%29+AS+%3Fo%29%0A++++++++%22%22%22%2C+from%3A+%22s%22%2C+to%3A+%22o%22%29%0A++%7D%0A%7D%0A)

## Data Generation

This section documents how the RDF data was generated.

### Download OSM data

```
wget https://download.geofabrik.de/europe/germany-latest.osm.pbf
```

### Filter OSM data

```bash
sudo apt install osmium-tool
```

```bash
osmium tags-filter germany-latest.osm.pbf 'railway=station' 'wheelchair' -o data.osm.pbf
```

### osm2rdf

```bash
docker pull adfreiburg/osm2rdf
```

Reproducible tag: `docker pull adfreiburg/osm2rdf:commit-001137d`

Create an `osm2rdf.sh` wrapper script:

```
#!/bin/bash

APP_UID="$(id -u)"
APP_GID="$(id -g)"

mkdir -p scratch
docker run --rm -u "$APP_UID:$APP_GID" -v "$(pwd):/data" -v "$(pwd)/scratch:/scratch" -w "/data" -it adfreiburg/osm2rdf -t /scratch \
  --no-osm-metadata \
  --no-node-geometric-relations \
  --no-way-geometric-relations \
  --no-relation-geometric-relations \
  --no-area-geometric-relations \
  "$@"
```

Invoke as follows:

```bash
./osm2rdf.sh data.osm.pbf -o data.osm.ttl.bz2
```

