
[GraphQL Example][https://data.aksw.org/mobydex/graphql?qtxt=query+%40pretty+%40debug%0A++%40prefix%28map%3A+%7B%0A++++geo%3A+%22http%3A%2F%2Fwww.opengis.net%2Font%2Fgeosparql%23%22%2C%0A++++geof%3A+%22http%3A%2F%2Fwww.opengis.net%2Fdef%2Ffunction%2Fgeosparql%2F%22%2C%0A++++osmt%3A+%22https%3A%2F%2Fwww.openstreetmap.org%2Fwiki%2FKey%3A%22%2C%0A++++rdf%3A+%22http%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%22%2C%0A++++rdfs%3A+%22http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%22%2C%0A++++afn%3A+%22http%3A%2F%2Fjena.apache.org%2FARQ%2Ffunction%23%22%2C%0A++++o%3A+%22https%3A%2F%2Fschema.coypu.org%2Fglobal%23%22%2C%0A++++norse%3A+%22https%3A%2F%2Fw3id.org%2Faksw%2Fnorse%23%22%0A++%7D%29%0A%7B%0A++type+%40bind%28of%3A+%22%27FeatureCollection%27%22%29%0A++features%28%0A++++area%3A+%22POLYGON+%28%286.475457372470345+51.7037981703763%2C+6.475457372470346+51.2481032780451%2C+7.544268491722988+51.24810327804511%2C+7.544268491722988+51.70379817037631%2C+6.475457372470345+51.7037981703763%29%29%22%0A++++limit%3A+10%0A++%29%0A++++%40pattern%28of%3A+%22%3Fs+a+o%3ATrainStation%22%29%0A%0A++++%23+Ad-hoc+binding+of+the+argument+%27area%27+to+a+SPARQL+filter+expression.%0A++++%40filter%28when%3A+%22bound%28%3Farea%29+%26%26+%3Farea+%21%3D+%27%27%22%2C+by%3A+%22EXISTS+%7B+%3Fs+geo%3AhasGeometry%2Fgeo%3AasWKT+%3Fwkt+FILTER%28geof%3AsfIntersects%28strdt%28%3Farea%2C+geo%3AwktLiteral%29%2C+%3Fwkt%29%29+%7D%22%2C+this%3A+%22s%22%2C+parent%3A+%22s%22%29%0A++%7B%0A++++type+%40bind%28of%3A+%22%27Feature%27%22%29++++%0A++++properties+%7B%0A++++++type+%40rdf%28iri%3A+%22rdf%3Atype%22%29%0A++++++po+%40pattern%28of%3A+%22%3Fs+%3Fp+%3Fo+.+FILTER%28%3Fp+NOT+IN+%28rdf%3Atype%2C+geo%3Ageometry%29%29%22%29+%40index%28by%3A+%22afn%3Alocalname%28%3Fp%29%22%2C+oneIf%3A+%22true%22%29%0A++++%7D%0A++++geometry+%40one%0A++++++%40pattern%28of%3A+%22%22%22%0A++++++++%3Fs+geo%3AhasGeometry%2Fgeo%3AasWKT+%3Fx+.%0A++++++++BIND%28STRDT%28STR%28geof%3AasGeoJSON%28geof%3AsimplifyDp%28%3Fx%2C+0.2%29%29%29%2C+norse%3Ajson%29+AS+%3Fo%29%0A++++++++%22%22%22%2C+from%3A+%22s%22%2C+to%3A+%22o%22%29%0A++%7D%0A%7D%0A]

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

