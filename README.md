usda plants database API
========================

**NOTE: This is not a USDA supported project**
**NOTE: The data behind the API is a bit stale, approx. from July 2016**

<br>

## base url

<https://plantsdb.xyz/>

## routes

- `/` (redirects to `/heartbeat`)
- `/heartbeat`
- `/search`

## params

on `/search` route only

- `fields`, e.g., `fields='Genus,Species'` (default: all fields returned)
- `limit`, e.g., `limit=10` (default: 10)
- `offset`, e.g., `offset=1` (default: 0)
- search on any fields in the output, e.g, `Genus=Pinus` or `Species=annua`

## examples

heartbeat

```
curl 'https://plantsdb.xyz/heartbeat' | jq .
#> {
#>   "routes": [
#>     "/search (HEAD, GET)",
#>     "/heartbeat"
#>   ]
#> }
```

search, no param

```
curl 'https://plantsdb.xyz/search' | jq .
#> {
#>   "count": 48022,
#>   "returned": 10,
#>   "data": [
#>     {
#>       "id": 1,
#>       "betydb_species_id": 3,
#>       "Genus": "Abies",
#>       "Species": "NA",
#>       "ScientificName": "Abies",
#> ... cutoff
```

search, limit

```
curl 'https://plantsdb.xyz/search?limit=3' | jq .
#>  "count": 48022,
#>  "returned": 3,
#>  "data": [
#>    {
#>      "id": 1,
#>      "betydb_species_id": 3
#> ... cutoff
```

search, offset

```
curl 'https://plantsdb.xyz/search?limit=3&offset=4' | jq .
```

fields, get back certain fields


```
curl 'https://plantsdb.xyz/search?limit=2&fields=Genus,Species,AcceptedSymbol' | jq .
#> {
#>   "count": 48022,
#>   "returned": 2,
#>   "data": [
#>     {
#>       "Genus": "Abies",
#>       "Species": "NA",
#>       "AcceptedSymbol": "ABIES"
#>     },
#>     {
#>       "Genus": "Abies",
#>       "Species": "alba",
#>       "AcceptedSymbol": "ABAL3"
#>     }
#>   ],
#>   "error": null
#> }
```
