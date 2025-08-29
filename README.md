
# Data Services
The data infrastructure reuses that of the former Coypu project.

## Relevant Note

* API for Marcus' API: https://mobydex.locoslab.com/controller-service/ (this should be documented on Locoslab page)
* Cells API: https://mobydex.locoslab.com/controller-service/projects/2/cells.json
* Computations API: https://mobydex.locoslab.com/controller-service/projects/2/computations.json
* Directions API: https://mobydex.locoslab.com/controller-service/computations/19/directions?origins=271&destinations=272&routes=true

## Summary

* Fuseki Server: https://copper.coypu.org/
* MobyDex SPARQL Endpoint: https://copper.coypu.org/mobydex
* Coypu SPARQL Endpoint: https://copper.coypu.org/coypu
* GraphQl Endpoint: https://copper.coypu.org/coypu/graphql

* Example Queries: https://docs.coypu.org/SparqlSampleQueries.html
* Full Documentation: https://docs.coypu.org

* Dataset List URZ: https://datasets.coypu.org/

## SPARQL Interface

### CURL Usage

⚠️ Don't forget the `query=`

* List all available named graphs in the store
```bash
curl https://copper.coypu.org/coypu --data-urlencode 'query=SELECT ?g { GRAPH ?g { } }'
```

<details>
  <summary>Show SPARQL Result Set (JSON, excerpt)</summary>

```json
{ "head": {
    "vars": [ "g" ]
  } ,
  "results": {
    "bindings": [
      { 
        "g": { "type": "uri" , "value": "https://data.coypu.org/genesis/" }
      } ,
      { 
        "g": { "type": "uri" , "value": "http://dalicc.net/licenselibrary/" }
      } ,
      { 
        "g": { "type": "uri" , "value": "https://data.coypu.org/events/wikievents-archive/" }
      }
    ]
  }
}
```

</details>


* Count the number of triples in the (ship) ports dataset
```bash
curl https://copper.coypu.org/coypu --data-urlencode \
  'query=SELECT (COUNT(*) AS ?c) { GRAPH <https://data.coypu.org/infrastructure/ports/> { ?s ?p ?o } }'
```

<details>
<summary>Show SPARQL Result Set (JSON)</summary>

```json
{ "head": {
    "vars": [ "c" ]
  } ,
  "results": {
    "bindings": [
      { 
        "c": { "type": "literal" , "datatype": "http://www.w3.org/2001/XMLSchema#integer" , "value": "174005" }
      }
    ]
  }
}
```

</details>

### Summary

* [Types and instance counts in the pilot region](https://api.triplydb.com/s/4a6GHLgiA)

### Visualize Query Results with Yasgui

![image](https://github.com/user-attachments/assets/7abc2a80-faf0-4aa1-b942-b43f604340e0)

Data in the example region: https://api.triplydb.com/s/pjI8x6_4b

<details>
  <summary>Show Query</summary>

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX geof: <http://www.opengis.net/def/function/geosparql/>
PREFIX spatial: <http://jena.apache.org/spatial#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>

SELECT ?graph ?geom ?geomColor ?geomTooltip (?geomTooltip AS ?geomLabel) {
  VALUES ?polygon {
    "POLYGON ((6.475457372470345 51.7037981703763, 6.475457372470346 51.2481032780451, 7.544268491722988 51.24810327804511, 7.544268491722988 51.70379817037631, 6.475457372470345 51.7037981703763))"^^geo:wktLiteral
  }
  
  # Use spatial:intersectBoxGeom for indexed lookup of candidates by BBOX
  # then filter by exact polygon using geof:sfIntersects
  GRAPH ?graph {
    ?x spatial:intersectBoxGeom(?polygon) .
    ?x geo:hasGeometry/geo:asWKT ?geom .
    FILTER(geof:sfIntersects(?geom, ?polygon))
  }
  
  # Color geometries based on the graph that contains them
  BIND (concat('#', substr(sha1(str(?graph)), 1, 6)) AS ?geomColor)
  
  BIND(strdt('Entity <a href="' + STR(?x) + '">' + STR(?x) + '</a> from graph ' + STR(?graph), rdf:HTML) as ?geomTooltip)
}
```

</details>

## GraphQL Interface

```graphql
{
  graphs @pattern(of: "GRAPH ?g { }") @pretty
}
```

```json
{
  "data": {
    "graphs": [
      "http://www.example.org/xg",
      "http://www.example.org/yg"
    ]
  },
  "errors": []
}
```

### GraphQL over SPARQL
In a nut shell, the top level graphql field contains the SPARQL query that specifies the initial sets of resources. Sub-fields are used to navigate along the properties of these resources (possibly using further SPARQL queries).

```graphql
query companies @debug @pretty
  @prefix(map: {
    rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    rdfs: "http://www.w3.org/2000/01/rdf-schema#",
    xsd: "http://www.w3.org/2001/XMLSchema#",
    schema: "http://schema.org/",
    wd: "http://www.wikidata.org/entity/",
    wdt: "http://www.wikidata.org/prop/direct/",
    geo: "http://www.opengis.net/ont/geosparql#",
    geof: "http://www.opengis.net/def/function/geosparql/",
    spatial: "http://jena.apache.org/spatial#"
    norse: "https://w3id.org/aksw/norse#"
  })
{
  Companies(limit: 10) @pattern(of: """
SELECT ?x ?geom {
  VALUES ?searchGeom {
    "POLYGON ((6.475457372470345 51.7037981703763, 6.475457372470346 51.2481032780451, 7.544268491722988 51.24810327804511, 7.544268491722988 51.70379817037631, 6.475457372470345 51.7037981703763))"^^geo:wktLiteral
  }
  LATERAL {
    SERVICE <cache:> {
      SELECT * {
        ?x spatial:intersectBoxGeom(?searchGeom) .
        # ?x wdt:P31 wd:Q4830453 . # business
        ?x geo:hasGeometry/geo:asWKT ?geom .
        FILTER(geof:sfIntersects(?geom, ?searchGeom))
        ?x wdt:P1128 ?rawEmployees .
    }
  }
}
}    """, to: "x") {
    # geom        @bind(of: "?searchGeom")
    id          @bind(of: "?x")
    label       @one @pattern(of: "?x rdfs:label ?l. FILTER(LANG(?l) = 'en')")
    employees   @one @pattern(of: "SELECT ?x (MIN(?y) AS ?yy) { ?x wdt:P1128 ?y } GROUP BY ?x")
    geom        @one @bind(of: "STRDT(STR(geof:asGeoJSON(?geom)), norse:json)")
    rdfData {
      po          @pattern(of: "?x ?p ?o", from: "x", to: "o") @index(by: "?p")
    }
  }
}
```

[Click here to run the query](https://data.aksw.org/mobydex/graphql?qtxt=query+companies+%40debug+%40pretty%0A++%40prefix%28map%3A+%7B%0A++++rdf%3A+%22http%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%22%2C%0A++++rdfs%3A+%22http%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%22%2C%0A++++xsd%3A+%22http%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%22%2C%0A++++schema%3A+%22http%3A%2F%2Fschema.org%2F%22%2C%0A++++wd%3A+%22http%3A%2F%2Fwww.wikidata.org%2Fentity%2F%22%2C%0A++++wdt%3A+%22http%3A%2F%2Fwww.wikidata.org%2Fprop%2Fdirect%2F%22%2C%0A++++geo%3A+%22http%3A%2F%2Fwww.opengis.net%2Font%2Fgeosparql%23%22%2C%0A++++geof%3A+%22http%3A%2F%2Fwww.opengis.net%2Fdef%2Ffunction%2Fgeosparql%2F%22%2C%0A++++spatial%3A+%22http%3A%2F%2Fjena.apache.org%2Fspatial%23%22%0A++++norse%3A+%22https%3A%2F%2Fw3id.org%2Faksw%2Fnorse%23%22%0A++%7D%29%0A%7B%0A++Companies%28limit%3A+10%29+%40pattern%28of%3A+%22%22%22%0ASELECT+%3Fx+%3Fgeom+%7B%0A++VALUES+%3FsearchGeom+%7B%0A++++%22POLYGON+%28%286.475457372470345+51.7037981703763%2C+6.475457372470346+51.2481032780451%2C+7.544268491722988+51.24810327804511%2C+7.544268491722988+51.70379817037631%2C+6.475457372470345+51.7037981703763%29%29%22%5E%5Egeo%3AwktLiteral%0A++%7D%0A++LATERAL+%7B%0A++++SERVICE+%3Ccache%3A%3E+%7B%0A++++++SELECT+*+%7B%0A++++++++%3Fx+spatial%3AintersectBoxGeom%28%3FsearchGeom%29+.%0A++++++++%23+%3Fx+wdt%3AP31+wd%3AQ4830453+.+%23+business%0A++++++++%3Fx+geo%3AhasGeometry%2Fgeo%3AasWKT+%3Fgeom+.%0A++++++++FILTER%28geof%3AsfIntersects%28%3Fgeom%2C+%3FsearchGeom%29%29%0A++++++++%3Fx+wdt%3AP1128+%3FrawEmployees+.%0A++++%7D%0A++%7D%0A%7D%0A%7D++++%22%22%22%2C+to%3A+%22x%22%29+%7B%0A++++%23+geom++++++++%40bind%28of%3A+%22%3FsearchGeom%22%29%0A++++id++++++++++%40bind%28of%3A+%22%3Fx%22%29%0A++++label+++++++%40one+%40pattern%28of%3A+%22%3Fx+rdfs%3Alabel+%3Fl.+FILTER%28LANG%28%3Fl%29+%3D+%27en%27%29%22%29%0A++++employees+++%40one+%40pattern%28of%3A+%22SELECT+%3Fx+%28MIN%28%3Fy%29+AS+%3Fyy%29+%7B+%3Fx+wdt%3AP1128+%3Fy+%7D+GROUP+BY+%3Fx%22%29%0A++++geom++++++++%40one+%40bind%28of%3A+%22STRDT%28STR%28geof%3AasGeoJSON%28%3Fgeom%29%29%2C+norse%3Ajson%29%22%29%0A++++rdfData+%7B%0A++++++po++++++++++%40pattern%28of%3A+%22%3Fx+%3Fp+%3Fo%22%2C+from%3A+%22x%22%2C+to%3A+%22o%22%29+%40index%28by%3A+%22%3Fp%22%29%0A++++%7D%0A++%7D%0A%7D%0A)

Output (excerpt):
```json
{
  "data": {
    "Companies": [
      {
        "id": "http://www.wikidata.org/entity/Q15781197",
        "label": null,
        "employees": 441,
        "geom": {
          "type": "Point",
          "coordinates": [
            7.224233,
            51.285559
          ]
        },
        "rdfData": {
          "http://schema.org/name": [
            "akf bank"
          ],
          "http://www.opengis.net/ont/geosparql#hasGeometry": [
            "http://www.wikidata.org/entity/Q15781197/geometry"
          ],
          "http://www.w3.org/1999/02/22-rdf-syntax-ns#type": [
            "http://wikiba.se/ontology#Item"
          ]
        }
      }
    ]
  }
}
```


## Notes
* *Named Graph* is essentially a dataset name.
* [Fuseki](https://jena.apache.org/documentation/fuseki2/) is a framework for hosting services over RDF data. It is a component of the [Apache Jena](https://github.com/apache/jena) Semantic Web framework.
* *Coypu* is the name of the project ([Website](https://coypu.org/)) in which the Fuseki server and the data loading pipelines were set up. We plan to keep the server running for at least a few more years (status from 2024-12-19).


