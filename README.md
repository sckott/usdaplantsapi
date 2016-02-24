usda plants API
===============

USDA plants database API

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
