
# Zensus Data in RDF

## RDFData

<img width="3957" height="1618" alt="image" src="https://github.com/user-attachments/assets/2d022dad-6bd0-437a-a7c0-8782d6345cc2" />

* Example Query: https://api.triplydb.com/s/NMRzNz68_
* SPARQL Endpoint: https://data.aksw.org/mobydex - `graph <https://data.aksw.org/zensus/2022/>`

## Raw Resources

* Link zum Zensusatlas: https://atlas.zensus2022.de/
* https://ergebnisse.zensus2022.de/datenbank/online/
* Download: https://plattform-npgeo-vfdb.hub.arcgis.com/datasets/esri-de-content::zensus-2022-gitterzellen/explore?layer=0&location=50.319172%2C11.799323%2C5.81

## Conversion

Used Process:
* Created small manuall mapping example
* Used ChatGPT 5o to complete the mapping based on the example
* A bit of manual cleanup and adjustments - e.g. chatgpt also got the coordinate order (x, y) wrong

ChatGPT Prompt:


```
erstelle ein tarql mapping für die folgenden spalten namen.
zu beachten:
- sonderzeichen (v.a. bindestriche und umlaute) sind mit _ zu ersetzen
- die Properties - falls du kein besseres Vokabular kennst - sollen im eg namespace mit Englischen Namen (camel case) benannt werden
- numerische werte sollen als xsd:decimal abgebildet werden. 


Hier ist ein Beispiel für die ersten 3 Spalten:

PREFIX eg: <http://www.example.org/>
CONSTRUCT {
  ?s
    a eg:Record ;
    eg:gitterId ?GITTER_ID_100m ;
    eg:inhabitants ?inhabitants ;
    eg:foreignersRatio ?foreignersRatio ;
    .
}
{
  BIND(iri(concat(str(eg:), ?OBJECTID)) AS ?s)
  BIND(xsd:decimal(?Einwohner) AS ?inhabitants)
  BIND(xsd:decimal(?Ausl_nderanteil) AS ?foreignersRatio)
}



id,GITTER_ID_100m,ARS,Einwohner,Ausländeranteil,Durchschnittsalter,Personen unter 18 Jahren,Personen 18 - 29 Jahre,Personen 30 - 49 Jahre,Personen 50 - 64 Jahre,Personen 65 Jahre und älter,Anteil der unter 18-Jährigen,Anteil der ab 65-Jährigen,Durchschnittliche Haushaltsgröße,Durchschnittliche Nettokaltmiete/qm,Durchschnittliche Fläche je Wohnung ,Durchschnittliche Fläche je Bewohner,Eigentümerquote,Leerstandsquote,Markaktive Leerstandsquote,Energieträger insgesamt,Gas,Heizöl,Holz/Holzpellets,Biomasse/Biogas,Solar/Geothermie/Wärmepumpe,Strom,Kohle,Fernwärme,kein Energieträger,Heizungsart insgesamt,Fernheizung,Etagenheizung,Blockheizung,Zentralheizung,Einzel-/ Mehrraumöfen,keine Heizung,Gebäude insgesamt,Gebäude vor 1919,Gebäude ab 1919 bis 1948,Gebäude ab 1949 bis 1978,Gebäude ab 1979 bis 1990,Gebäude ab 1991 bis 2000,Gebäude ab 2001 bis 2010,Gebäude ab 2011 bis 2019,Gebäude ab 2020 und später,Shape__Area,Shape__Length
```


