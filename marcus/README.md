
[List available types - via owl:Class](https://yasgui.triply.cc/#query=PREFIX%20owl%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0APREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0ASELECT%20*%20WHERE%20%7B%0A%20%20%3Ftype%20a%20owl%3AClass%20.%0A%20%20OPTIONAL%20%7B%20%3Ftype%20rdfs%3Alabel%20%3Fl%20%7D%0A%7D%0ALIMIT%201000%0A&endpoint=https%3A%2F%2Fdata.aksw.org%2Fmobydex&requestMethod=POST&tabTitle=Query%201&headers=%7B%7D&contentTypeConstruct=application%2Fn-triples%2C*%2F*%3Bq%3D0.9&contentTypeSelect=application%2Fsparql-results%2Bjson%2C*%2F*%3Bq%3D0.9&outputFormat=table)
```sparql
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT * WHERE {
  ?type a owl:Class .
  OPTIONAL { ?type rdfs:label ?l }
}
LIMIT 1000
```

[List available types - via scanning (a sample of) instances](https://yasgui.triply.cc/#query=PREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0ASELECT%20*%20WHERE%20%7B%0A%20%20SERVICE%20%3Ccache%3A%3E%20%7B%20%7B%20SELECT%20DISTINCT%20%3Ftype%20%7B%20%3Fs%20a%20%3Ftype%20%7D%20LIMIT%2010000%20%7D%20%7D%0A%20%20OPTIONAL%20%7B%20%3Ftype%20rdfs%3Alabel%20%3Fl%20%7D%0A%7D%0ALIMIT%201000&endpoint=https%3A%2F%2Fdata.aksw.org%2Fmobydex&requestMethod=POST&tabTitle=Query%201&headers=%7B%7D&contentTypeConstruct=application%2Fn-triples%2C*%2F*%3Bq%3D0.9&contentTypeSelect=application%2Fsparql-results%2Bjson%2C*%2F*%3Bq%3D0.9&outputFormat=table)
```sparql
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT * WHERE {
  SERVICE <cache:> { { SELECT DISTINCT ?type { ?s a ?type } LIMIT 10000 } }
  OPTIONAL { ?type rdfs:label ?l }
}
LIMIT 1000
```

[SPARQL Example - Aggregate per grid cell](https://yasgui.triply.cc/#query=PREFIX%20spatialF%3A%20%3Chttp%3A%2F%2Fjena.apache.org%2Fspatial%23%3E%0APREFIX%20geof%3A%20%3Chttp%3A%2F%2Fwww.opengis.net%2Fdef%2Ffunction%2Fgeosparql%2F%3E%0APREFIX%20geo%3A%20%3Chttp%3A%2F%2Fwww.opengis.net%2Font%2Fgeosparql%23%3E%0APREFIX%20rdf%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0A%0ASELECT%20%3Fcell1Wkt%20%3Fcell1WktColor%20%3Fcell2Wkt%20%3Fcell2WktColor%20%3Fcount%20WHERE%20%7B%0A%20%20BIND(%22blue%22%20AS%20%3Fcell1WktColor)%0A%20%20BIND(%22red%22%20AS%20%3Fcell2WktColor)%0A%20%20VALUES%20%3FareaWkt%20%7B%0A%20%20%20%20%22POLYGON%20((6.475457372470345%2051.7037981703763%2C%206.475457372470346%2051.2481032780451%2C%207.544268491722988%2051.24810327804511%2C%207.544268491722988%2051.70379817037631%2C%206.475457372470345%2051.7037981703763))%22%5E%5Egeo%3AwktLiteral%0A%20%20%7D%0A%20%20LATERAL%20%7B%0A%20%20%20%20SELECT%20%3FareaWkt%20%3Fcell1Wkt%20(geof%3Acollect(%3Fcell2MemberWkt)%20AS%20%3Fcell2Wkt)%20(COUNT(*)%20AS%20%3Fcount)%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%7B%20SELECT%20*%20%7B%0A%20%20%20%20%20%20%20%20GRAPH%20%3Chttps%3A%2F%2Fdata.aksw.org%2Fzensus%2F2022%2F%3E%20%7B%0A%20%20%20%20%20%20%20%20%20%20%3Fcell1%20spatialF%3AintersectBoxGeom(%3FareaWkt)%20.%0A%20%20%20%20%20%20%20%20%20%20%3Fcell1%20geo%3AhasGeometry%2Fgeo%3AasWKT%20%3Fcell1Wkt%20.%0A%20%20%20%20%20%20%20%20%20%20FILTER(!bound(%3FareaWkt)%20%7C%7C%20geof%3AsfIntersects(%3Fcell1Wkt%2C%20%3FareaWkt))%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%7D%20LIMIT%201000%20%7D%0A%20%20%20%20%20%20%23%20LATERAL%20%7B%0A%20%20%20%20%20%20SERVICE%20%3Cloop%3Aconcurrent%2B10-1%3Abulk%2B1%3A%3E%20%7B%0A%20%20%20%20%20%20%20%20GRAPH%20%3Chttps%3A%2F%2Fdata.mobydex.org%2Fosm%2F20250903%2F15mincity%2F%3E%20%7B%0A%20%20%20%20%20%20%20%20%20%20%3Fcell2%20spatialF%3AintersectBoxGeom(%3Fcell1Wkt)%20.%0A%20%20%20%20%20%20%20%20%20%20%3Fcell2%20geo%3AhasGeometry%2Fgeo%3AasWKT%20%3Fcell2MemberWkt%20.%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%20GROUP%20BY%20%3FareaWkt%20%3Fcell1Wkt%0A%20%20%7D%0A%7D%0A&endpoint=https%3A%2F%2Fdata.aksw.org%2Fmobydex&requestMethod=POST&tabTitle=Query%201&headers=%7B%7D&contentTypeConstruct=application%2Fn-triples%2C*%2F*%3Bq%3D0.9&contentTypeSelect=application%2Fsparql-results%2Bjson%2C*%2F*%3Bq%3D0.9&outputFormat=geo&outputSettings=%7B%7D)

```sparql
PREFIX spatialF: <http://jena.apache.org/spatial#>
PREFIX geof: <http://www.opengis.net/def/function/geosparql/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?cell1Wkt ?cell1WktColor ?cell2Wkt ?cell2WktColor ?count WHERE {
  BIND("blue" AS ?cell1WktColor)
  BIND("red" AS ?cell2WktColor)
  VALUES ?areaWkt {
    "POLYGON ((6.475457372470345 51.7037981703763, 6.475457372470346 51.2481032780451, 7.544268491722988 51.24810327804511, 7.544268491722988 51.70379817037631, 6.475457372470345 51.7037981703763))"^^geo:wktLiteral
  }
  LATERAL {
    SELECT ?areaWkt ?cell1Wkt (geof:collect(?cell2MemberWkt) AS ?cell2Wkt) (COUNT(*) AS ?count)
    {
      { SELECT * {
        GRAPH <https://data.aksw.org/zensus/2022/> {
          ?cell1 spatialF:intersectBoxGeom(?areaWkt) .
          ?cell1 geo:hasGeometry/geo:asWKT ?cell1Wkt .
          FILTER(!bound(?areaWkt) || geof:sfIntersects(?cell1Wkt, ?areaWkt))
        }
      } LIMIT 1000 }
      # LATERAL {
      SERVICE <loop:concurrent+10-1:bulk+1:> {
        GRAPH <https://data.mobydex.org/osm/20250903/15mincity/> {
          ?cell2 spatialF:intersectBoxGeom(?cell1Wkt) .
          ?cell2 geo:hasGeometry/geo:asWKT ?cell2MemberWkt .
        }
      }
    } GROUP BY ?areaWkt ?cell1Wkt
  }
}
```


[SPARQL Example - Bulk Polygon Request Example](https://api.triplydb.com/s/T-SZYko7d)

```sparql
PREFIX spatialF: <http://jena.apache.org/spatial#>
PREFIX geof: <http://www.opengis.net/def/function/geosparql/>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?id ?s ?wkt WHERE {
  VALUES (?id ?area) {
    (1 "POLYGON ((6.475457372470345 51.7037981703763, 6.475457372470346 51.2481032780451, 7.544268491722988 51.24810327804511, 7.544268491722988 51.70379817037631, 6.475457372470345 51.7037981703763))"^^geo:wktLiteral)
    (2 "POLYGON ((6.475457372470345 51.7037981703763, 6.475457372470346 51.2481032780451, 7.544268491722988 51.24810327804511, 7.544268491722988 51.70379817037631, 6.475457372470345 51.7037981703763))"^^geo:wktLiteral)
  }
  LATERAL {
    SELECT * { 
      GRAPH <https://data.aksw.org/zensus/2022/> {
        ?s spatialF:intersectBoxGeom(?area) .
        ?s geo:hasGeometry/geo:asWKT ?wkt .    
        FILTER(!bound(?area) || geof:sfIntersects(?wkt, ?area))
     }
    } LIMIT 2
  }
}
LIMIT 10
```


[GraphQL Example](https://data.aksw.org/mobydex/graphql?qtxt=query+%40pretty+%40debug%0A++%40prefix%28map%3A+%7B%0A++++geo%3A+%22http%3A%2F%2Fwww.opengis.net%2Font%2Fgeosparql%23%22%2C%0A++++geof%3A+%22http%3A%2F%2Fwww.opengis.net%2Fdef%2Ffunction%2Fgeosparql%2F%22%2C%0A++++osmt%3A+%22https%3A%2F%2Fwww.openstreetmap.org%2Fwiki%2FKey%3A%22%2C%0A++++rdf%3A+%22http%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%22%2C%0A++++rdfs%3A+%22http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%22%2C%0A++++afn%3A+%22http%3A%2F%2Fjena.apache.org%2FARQ%2Ffunction%23%22%2C%0A++++o%3A+%22https%3A%2F%2Fschema.coypu.org%2Fglobal%23%22%2C%0A++++norse%3A+%22https%3A%2F%2Fw3id.org%2Faksw%2Fnorse%23%22%0A++%7D%29%0A%7B%0A++type+%40bind%28of%3A+%22%27FeatureCollection%27%22%29%0A++features%28%0A++++area%3A+%22POLYGON+%28%286.475457372470345+51.7037981703763%2C+6.475457372470346+51.2481032780451%2C+7.544268491722988+51.24810327804511%2C+7.544268491722988+51.70379817037631%2C+6.475457372470345+51.7037981703763%29%29%22%0A++++limit%3A+10%0A++%29%0A++++%40pattern%28of%3A+%22%3Fs+a+o%3ATrainStation%22%29%0A%0A++++%23+Ad-hoc+binding+of+the+argument+%27area%27+to+a+SPARQL+filter+expression.%0A++++%40filter%28when%3A+%22bound%28%3Farea%29+%26%26+%3Farea+%21%3D+%27%27%22%2C+by%3A+%22EXISTS+%7B+%3Fs+geo%3AhasGeometry%2Fgeo%3AasWKT+%3Fwkt+FILTER%28geof%3AsfIntersects%28strdt%28%3Farea%2C+geo%3AwktLiteral%29%2C+%3Fwkt%29%29+%7D%22%2C+this%3A+%22s%22%2C+parent%3A+%22s%22%29%0A++%7B%0A++++type+%40bind%28of%3A+%22%27Feature%27%22%29++++%0A++++properties+%7B%0A++++++type+%40rdf%28iri%3A+%22rdf%3Atype%22%29%0A++++++po+%40pattern%28of%3A+%22%3Fs+%3Fp+%3Fo+.+FILTER%28%3Fp+NOT+IN+%28rdf%3Atype%2C+geo%3Ageometry%29%29%22%29+%40index%28by%3A+%22afn%3Alocalname%28%3Fp%29%22%2C+oneIf%3A+%22true%22%29%0A++++%7D%0A++++geometry+%40one%0A++++++%40pattern%28of%3A+%22%22%22%0A++++++++%3Fs+geo%3AhasGeometry%2Fgeo%3AasWKT+%3Fx+.%0A++++++++BIND%28STRDT%28STR%28geof%3AasGeoJSON%28geof%3AsimplifyDp%28%3Fx%2C+0.2%29%29%29%2C+norse%3Ajson%29+AS+%3Fo%29%0A++++++++%22%22%22%2C+from%3A+%22s%22%2C+to%3A+%22o%22%29%0A++%7D%0A%7D%0A)

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

