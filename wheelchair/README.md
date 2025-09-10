## Accessibility Data

### Trainstations + Wheelchair Accessibility

<img width="300" alt="image" src="https://github.com/user-attachments/assets/8b52fd7d-67a4-47f8-b1bc-7da9ea14cf83" />

* YasGui Link: https://api.triplydb.com/s/DA90SQxJm

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

