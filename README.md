
# Data Services
The data infrastructure reuses that of the former Coypu project.

## Relevant Note

* API for Marcus' API: https://mobydex.locoslab.com/controller-service/ (this should be documented on Locoslab page)

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

## Notes
* *Named Graph* is essentially a dataset name.
* [Fuseki](https://jena.apache.org/documentation/fuseki2/) is a framework for hosting services over RDF data. It is a component of the [Apache Jena](https://github.com/apache/jena) Semantic Web framework.
* *Coypu* is the name of the project ([Website](https://coypu.org/)) in which the Fuseki server and the data loading pipelines were set up. We plan to keep the server running for at least a few more years (status from 2024-12-19).


