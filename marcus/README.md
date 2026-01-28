```graphql
query @pretty @debug
  @prefix(map: {
    geo: "http://www.opengis.net/ont/geosparql#",
    geof: "http://www.opengis.net/def/function/geosparql/",
    osmt: "https://www.openstreetmap.org/wiki/Key:",
    rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    rdfs: "http://www.w3.org/2000/01/rdf-schema#",
    afn: "http://jena.apache.org/ARQ/function#",
    o: "https://schema.coypu.org/global#",
    norse: "https://w3id.org/aksw/norse#"
  })
{
  type @bind(of: "'FeatureCollection'")
  features(
    area: "POLYGON ((6.475457372470345 51.7037981703763, 6.475457372470346 51.2481032780451, 7.544268491722988 51.24810327804511, 7.544268491722988 51.70379817037631, 6.475457372470345 51.7037981703763))"
    limit: 10
  )
    @pattern(of: "?s a o:TrainStation")

    # Ad-hoc binding of the argument 'area' to a SPARQL filter expression.
    @filter(when: "bound(?area) && ?area != ''", by: "EXISTS { ?s geo:hasGeometry/geo:asWKT ?wkt FILTER(geof:sfIntersects(strdt(?area, geo:wktLiteral), ?wkt)) }", this: "s", parent: "s")
  {
    type @bind(of: "'Feature'")    
    properties {
      type @rdf(iri: "rdf:type")
      po @pattern(of: "?s ?p ?o . FILTER(?p NOT IN (rdf:type, geo:geometry))") @index(by: "afn:localname(?p)", oneIf: "true")
    }
    geometry @one
      @pattern(of: """
        ?s geo:hasGeometry/geo:asWKT ?x .
        BIND(STRDT(STR(geof:asGeoJSON(geof:simplifyDp(?x, 0.2))), norse:json) AS ?o)
        """, from: "s", to: "o")
  }
}
```

```json
{
  "data": {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "properties": {
          "type": [
            "https://www.openstreetmap.org/node",
            "https://schema.coypu.org/global#TrainStation"
          ],
          "hasGeometry": "https://osm2rdf.cs.uni-freiburg.de/rdf/geom#osm_node_449582627",
          "facts": 13,
          "wikidata": "http://www.wikidata.org/entity/Q472955",
          "wikipedia": "https://de.wikipedia.org/wiki/Oberhausen%20Hauptbahnhof",
          "name": "Oberhausen Hbf",
          "operator": "DB Netz AG",
          "public_transport": "station",
          "railway": "station",
          "ref": "EOB",
          "station_category": "2",
          "uic_ref": "8000286",
          "website": "https://www.bahnhof.de/bahnhof-de/Oberhausen_Hbf",
          "wheelchair": "yes",
          "wikidata": "Q472955",
          "wikipedia": "de:Oberhausen Hauptbahnhof"
        },
        "geometry": {
          "type": "Point",
          "coordinates": [
            6.8516806,
            51.4749062
          ]
        }
      }
    ]
  }
}
```

